//
//  ViewController.swift
//  ScreenTransition
//
//  Created by USER on 2019/12/17.
//  Copyright © 2019 Akidon. All rights reserved.
//

import UIKit

class CameraController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    
    @IBOutlet weak var cameraView: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = "[スタート]押すと写真とれるで"
        
    }
    
    // カメラの撮影開始
    @IBAction func startCamera(_ sender: Any) {
        let sourceType:UIImagePickerController.SourceType =
            UIImagePickerController.SourceType.camera
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerController.SourceType.camera){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
        }
        else{
            label.text = "errorやで"
            
        }
    }
    
    //　撮影が完了時した時に呼ばれる
    func imagePickerController(_ imagePicker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        if let pickedImage = info[.originalImage]
            as? UIImage {
            
            cameraView.contentMode = .scaleAspectFit
            cameraView.image = pickedImage
            
        }
 
        //閉じる処理
        imagePicker.dismiss(animated: true, completion: nil)
        label.text = "[セーブ]押すと写真保存するで "
        
    }
    
    // 撮影がキャンセルされた時に呼ばれる
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        label.text = "キャンセルされたわ"
    }
    
    
    // 写真を保存
    @IBAction func savePicture(_ sender: Any) {
        let image:UIImage! = cameraView.image
        
        if image != nil {
            UIImageWriteToSavedPhotosAlbum(
                image,
                self,
                #selector(CameraController.image(_:didFinishSavingWithError:contextInfo:)),
                nil)
        }
        else{
            label.text = "すまん、失敗したわ"
        }
        
    }
    
    // 書き込み完了結果の受け取り
    @objc func image(_ image: UIImage,
                     didFinishSavingWithError error: NSError!,
                     contextInfo: UnsafeMutableRawPointer) {
        
        if error != nil {
            print(error.code)
            label.text = "すまん、セーブに失敗したわ"
        }
        else{
            label.text = "セーブに成功したで！"
        }
    }
    
    // アルバムを表示
    @IBAction func showAlbum(_ sender: Any) {
        let sourceType:UIImagePickerController.SourceType =
            UIImagePickerController.SourceType.photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerController.SourceType.photoLibrary){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
            label.text = "[スタート]押すと写真とれるで！"
        }
        else{
            label.text = "エラーやわ"
            
        }
        
    }
 
}
