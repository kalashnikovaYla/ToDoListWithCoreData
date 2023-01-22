//
//  ViewController.swift
//  ToDoListWithCoreData
//
//  Created by sss on 22.01.2023.
//

import UIKit

final class ViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    private let identifier = "Cell"
    private var tableView: UITableView!
    
    private var models = [Task]()
    
    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter
    }()
    
    //MARK: -  Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsTableView()

        title = "Список задач"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonIsTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllTasks()
    }
    
    //MARK: - Methods
    
    @objc func addButtonIsTapped() {
        let alertController = UIAlertController(title: "Новая задача", message: "Добавьте новую задачу", preferredStyle: .alert)
        
        alertController.addTextField()
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { [weak self] _ in
            guard
                let textField = alertController.textFields?.first,
                    let text = textField.text,
                    !text.isEmpty
            else {return}
            self?.createNewTask(name: text)
        }
        alertController.addAction(saveAction)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    

    private func settingsTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = .tertiarySystemGroupedBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .secondarySystemFill
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    ///Show tasks
    private func getAllTasks() {
        do {
            models = try context.fetch(Task.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch let error {
           print(error)
        }
    }
    
    ///Save new task
    private func createNewTask(name: String) {
        let newTask = Task(context: context)
        newTask.name = name
        newTask.date = Date()
        do {
            try context.save()
            getAllTasks()
        } catch let error {
            print(error)
        }
    }
    
    ///Deletet selected task
    private func deleteTask(task: Task) {
        context.delete(task)
        do {
            try context.save()
            getAllTasks()
        } catch let error {
            print(error)
        }
    }
    
    ///Change task name
    private func updateTask(task: Task, newName: String) {
        task.name = newName
        do {
            try context.save()
            getAllTasks()
        } catch let error {
            print(error)
        }
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let model = models[indexPath.row]
        
        var configuration = cell.defaultContentConfiguration()
        configuration.text = model.name
        
        if let date = model.date {
            configuration.secondaryText = dateFormatter.string(from: date)
        }
        cell.contentConfiguration = configuration
        cell.backgroundColor = .tertiarySystemBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let task = models[indexPath.row]
        
        let alertController = UIAlertController(title: "Редактировать", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        alertController.textFields?.first?.text = task.name
        let saveAction = UIAlertAction(title: "Изменить", style: .default) { [weak self] _ in
            guard let textField = alertController.textFields?.first, let text = textField.text, !text.isEmpty else {return}
            self?.updateTask(task: task, newName: text)
        }
        alertController.addAction(saveAction)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {return}
        let task = models[indexPath.row]
        deleteTask(task: task)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
