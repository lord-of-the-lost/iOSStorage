//
//  DocumentsViewController.swift
//  iOSStorage
//
//  Created by Николай Игнатов on 25.05.2023.
//

import UIKit

final class DocumentsViewController: UIViewController {
    
    private var files: [String] = []
    
    private lazy var documentFilesList: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var addFileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.app.fill"), for: .normal)
        button.addTarget(self, action: #selector(addFile), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupNavBar()
        loadFiles()
    }
    
    @objc private func addFile() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(documentFilesList)
    }
    
    private func setupNavBar() {
        title = "Documents"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addFileButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            documentFilesList.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            documentFilesList.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            documentFilesList.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            documentFilesList.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadFiles() {
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            files.removeAll()
            
            for fileURL in fileURLs {
                files.append(fileURL.lastPathComponent)
            }
            
            documentFilesList.reloadData()
        } catch {
            print("Ошибка при загрузке файлов: \(error)")
        }
    }
    
    private func deleteFile(at indexPath: IndexPath) {
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        let fileName = files[indexPath.row]
        let fileURL = documentsURL.appendingPathComponent(fileName)
        
        do {
            try fileManager.removeItem(at: fileURL)
            files.remove(at: indexPath.row)
            documentFilesList.deleteRows(at: [indexPath], with: .automatic)
        } catch {
            print("Ошибка при удалении файла: \(error)")
        }
    }
    
    private func saveImageToDocumentsDirectory(_ image: UIImage) {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        let fileURL = documentsURL.appendingPathComponent("\(UUID().uuidString).jpg")
        
        if let imageData = image.jpegData(compressionQuality: 1) {
            do {
                try imageData.write(to: fileURL)
                files.append(fileURL.lastPathComponent)
                documentFilesList.reloadData()
            } catch {
                print("Ошибка при сохранении изображения: \(error)")
            }
        }
    }
}

extension DocumentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else {
            return UITableViewCell() }
        cell.textLabel?.text = files[indexPath.row]
        return cell
    }
}

extension DocumentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteFile(at: indexPath)
        }
    }
}

extension DocumentsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[.originalImage] as? UIImage {
            saveImageToDocumentsDirectory(image)
        }
    }
}
