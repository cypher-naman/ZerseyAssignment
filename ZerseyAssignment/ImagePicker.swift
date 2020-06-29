//
//  ImagePicker.swift
//  ZerseyAssignment
//
//  Created by Naman Sharma on 29/06/20.
//  Copyright © 2020 Naman Sharma. All rights reserved.
//
import UIKit

public protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?)
}

open class ImagePicker: NSObject {

    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?

    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()

        super.init()

        self.presentationController = presentationController
        self.delegate = delegate

        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
    }

    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }

        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }

    public func present(from sourceView: UIView) {

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if let action = self.action(for: .camera, title: "Take photo") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Photo library") {
            alertController.addAction(action)
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }

        self.presentationController?.present(alertController, animated: true)
    }

    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)

        self.delegate?.didSelect(image: image)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: image)
    }
}

extension ImagePicker: UINavigationControllerDelegate {

}
//import Foundation
//import UIKit
//import Firebase
//
//public protocol ImagePickerDelegate: class {
//    func didSelect(image: UIImage?)
//}
//
//open class ImagePicker: NSObject {
//
//    private let pickerController: UIImagePickerController
//    private weak var presentationController: UIViewController?
//    private weak var delegate: ImagePickerDelegate?
//
//    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
//        self.pickerController = UIImagePickerController()
//
//        super.init()
//
//        self.presentationController = presentationController
//        self.delegate = delegate
//
//        self.pickerController.delegate = self
//        self.pickerController.allowsEditing = false
//        self.pickerController.mediaTypes = ["public.image"]
//    }
//
//    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
//        guard UIImagePickerController.isSourceTypeAvailable(type) else {
//            return nil
//        }
//
//        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
//            self.pickerController.sourceType = type
//            self.presentationController?.present(self.pickerController, animated: true)
//        }
//    }
//
//    public func present(from sourceView: UIView) {
//
//        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
//            alertController.addAction(action)
//        }
//        if let action = self.action(for: .photoLibrary, title: "Photo library") {
//            alertController.addAction(action)
//        }
//
//        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            alertController.popoverPresentationController?.sourceView = sourceView
//            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
//            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
//        }
//
//        self.presentationController?.present(alertController, animated: true)
//    }
//
//    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
//        controller.dismiss(animated: true, completion: nil)
//
//        self.delegate?.didSelect(image: image)
////                guard let imageSelected = image else {return}
////                guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {return}
////        //        let storageRef = Storage.storage(url: "gs://zerseyassignment.appspot.com").reference().child("doodles")
////                let storageRef = Storage.storage().reference(forURL: "gs://zerseyassignment.appspot.com").child("doodles")
////
////                let metadata = StorageMetadata()
////                metadata.contentType = "image/jpg"
////                storageRef.putData(imageData, metadata: metadata) { (storageMetaData, error) in
////                    if error != nil{
////                        print("no error")
////                        storageRef.downloadURL { (url, _ error) in
////                            if let url = url {
////                                print(url.absoluteString)
////                            }
////                        }
////                    }else{
////                        print("error")
////                    }
////                }
//    }
//}
//
//extension ImagePicker: UIImagePickerControllerDelegate {
//
//    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        self.pickerController(picker, didSelect: nil)
//    }
//
//    public func imagePickerController(_ picker: UIImagePickerController,
//                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//        guard let image = info[.editedImage] as? UIImage else {
//            return self.pickerController(picker, didSelect: nil)
//        }
//        self.pickerController(picker, didSelect: image)
//    }
//}
//
//extension ImagePicker: UINavigationControllerDelegate {
//
//}
