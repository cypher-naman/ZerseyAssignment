//
//  ViewController.swift
//  ZerseyAssignment
//
//  Created by Naman Sharma on 28/06/20.
//  Copyright © 2020 Naman Sharma. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import Firebase

class ViewController: UIViewController {
    let drawingBoard = DrawingBoard()
    var imagePicker: ImagePicker!
    var imageToBeUploaded : UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        drawingBoard.backgroundColor = .white
        let colorStack : UIStackView = UIStackView(arrangedSubviews: [redColorButton, greenColorButton, yellowColorButton, blueColorButton, blackColorButton])
        colorStack.distribution = .fillEqually
        colorStack.spacing = 2
        
        let upperStackView = UIStackView(arrangedSubviews: [colorStack, undoButton])
        view.addSubview(upperStackView)
        upperStackView.spacing = 5
        upperStackView.translatesAutoresizingMaskIntoConstraints = false
        upperStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        upperStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        upperStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        let lowerStackView : UIStackView  = UIStackView(arrangedSubviews: [clearButton,  imageButton, uploadButton])
        lowerStackView.distribution = .fillEqually
        view.addSubview(lowerStackView)
        lowerStackView.translatesAutoresizingMaskIntoConstraints = false
        lowerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        lowerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        lowerStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    var undoButton: UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Undo", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(performUndo), for: .touchUpInside)
        return button
    }
    
    var clearButton: UIButton {
        let button = UIButton(type: .system)
        button.setTitle("clear", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(performClear), for: .touchUpInside)
        return button
    }
    
    var imageButton: UIButton {
        let button = UIButton(type: .system)
        button.setTitle("save", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
        return button
    }
    
    var uploadButton: UIButton {
        let button = UIButton(type: .system)
        button.setTitle("upload", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(upload), for: .touchUpInside)
        return button
    }
    
    var redColorButton: UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = .red
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(selectColor), for: .touchUpInside)
        return button
    }
    var greenColorButton: UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = .green
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(selectColor), for: .touchUpInside)
        return button
    }
    var yellowColorButton: UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = .yellow
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(selectColor), for: .touchUpInside)
        return button
    }
    var blueColorButton: UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(selectColor), for: .touchUpInside)
        return button
    }
    var blackColorButton: UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(selectColor), for: .touchUpInside)
        return button
    }
    
    
    @objc private func saveImage() {
        //save
        let doodledImage = drawingBoard.asImage()
        let activity = UIActivityViewController(activityItems: [doodledImage],
                                                applicationActivities: nil)
        present(activity, animated: true)
    }
    
    @objc private func upload(button : UIButton) {
        //upload
        self.imagePicker.present(from: button)
    }
    
    @objc private func selectColor(button : UIButton) {
        //select color
        drawingBoard.colorOfLine = button.backgroundColor ?? .black
    }
    
    @objc private func performUndo() {
        //undo
        drawingBoard.undo()
    }
    
    @objc private func performClear() {
        //clear
        drawingBoard.clear()
    }
    
    override func loadView() {
        self.view = drawingBoard
    }
}

extension ViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        //uploading to firebase
        guard let image = image,
            let data = image.jpegData(compressionQuality: 1.0) else {
                presentAlert(title: "Error", message: "Something went wrong")
                return
        }
        
        let imageName = UUID().uuidString
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        let imageReference = Storage.storage(url: "gs://zerseyassignment.appspot.com").reference()
            .child(MyKeys.imagesFolder)
            .child(imageName)
        
        imageReference.putData(data, metadata: metaData) { (metadata, err) in
            if let err = err {
                self.presentAlert(title: "Error", message: err.localizedDescription)
                return
            }
            
            imageReference.downloadURL(completion: { (url, err) in
                if let err = err {
                    self.presentAlert(title: "Error", message: err.localizedDescription)
                    return
                }
                
                guard let url = url else {
                    self.presentAlert(title: "Error", message: "Something went wrong")
                    return
                }
                
                let dataReference = Firestore.firestore().collection(MyKeys.imagesCollection).document()
                let documentUid = dataReference.documentID
                
                let urlString = url.absoluteString
                
                let data = [
                    MyKeys.uid: documentUid,
                    MyKeys.imageUrl: urlString
                ]
                
                dataReference.setData(data, completion: { (err) in
                    if let err = err {
                        self.presentAlert(title: "Error", message: err.localizedDescription)
                        return
                    }
                    
                    UserDefaults.standard.set(documentUid, forKey: MyKeys.uid)
                    self.imageToBeUploaded = UIImage()
                    self.presentAlert(title: "Success", message: "Successfully save image to database")
                })
                
            })
        }
    }

    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
