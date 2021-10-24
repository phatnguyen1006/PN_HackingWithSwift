//
//  ViewController.swift
//  NamesToFace
//
//  Created by Phat Nguyen on 14/10/2021.
//

import UIKit

class ViewController: UICollectionViewController {
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor = .white

        // Add Button
        addBtn()
        
        // Load data
        loadDataWhenAppRun()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Can't dequeue PersonCell.")
        }
        
        let person = people[indexPath.item]
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)   // URL.path
        
        // style cell
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let vc = UIAlertController(title: "Choose option", message: nil, preferredStyle: .actionSheet)
        
        let renameAction = UIAlertAction(title: "Rename", style: .default) { [weak self] action in
            self?.showRenameAlert(person)
        }
        let removeAction = UIAlertAction(title: "Delete", style: .default) { [weak self] action in
            self?.removePersonFromList(person)
        }
        removeAction.setValue(UIColor.red, forKey: "TitleTextColor")
        
        vc.addAction(renameAction)
        vc.addAction(removeAction)
        present(vc, animated: true, completion: nil)
    }
    
    func loadDataWhenAppRun() {
        let defaults = UserDefaults.standard
        
        if let savedData = defaults.object(forKey: "people") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                people = try jsonDecoder.decode([Person].self, from: savedData)
            } catch {
                print("Failed to load data")
            }
        }
    }
    
    func showRenameAlert(_ person: Person) {
        let ac = UIAlertController(title: "Rename Person", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak ac] _ in
            guard let name = ac?.textFields?[0].text else { return }
            person.name = name
            
            self?.collectionView.reloadData()
            self?.save()
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(ac, animated: true, completion: nil)
    }
    
    func removePersonFromList(_ person: Person) {
        people.removeAll { personInline in
            personInline == person
        }
        
        self.collectionView.reloadData()
        self.save()
    }
    
    func addBtn() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.leftBarButtonItem?.tintColor = .blue
    }
    
    @objc func addTapped() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(people) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
        } else {
            printContent("Failed to save data")
        }
    }
}


// Extension for Choose Photo from Photo Library
extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // After finish -> Image will be returned inside info.
        if let image = info[.editedImage] as? UIImage {
            let imageName = UUID().uuidString
            let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
            
            if let jpegData = image.jpegData(compressionQuality: 0.8) {
                try? jpegData.write(to: imagePath)
            }
            
            // Save to Person List
            self.people.append(Person(name: "Unknown", image: imageName))
            collectionView.reloadData()
            save()
        }
        // Dismiss the Avatar image.
        dismiss(animated: true, completion: nil)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
