//
//  SAPrimeraViewController.swift
//  App_Padawan_Jedi_Sith_Callback_Async
//
//  Created by formador on 22/3/17.
//  Copyright © 2017 formador. All rights reserved.
//

import UIKit

class SAPrimeraViewController: UIViewController {
    
    //MARK: - Variables locales
    let sImageUrl = "https://www.otogami.com/uncroped/03/42/img34206.jpg"
    let sWebUrl = "https://es.wikipedia.org/wiki/Wikipedia:Portada"
    typealias callBackImageData = (_ imageData : UIImage) -> ()
    typealias callBackWebdata = (_ webData : URLRequest) -> ()
    
    //MARK: - IBOutlets
    @IBOutlet weak var myImageViewCustom: UIImageView!
    @IBOutlet weak var myWebViewCustom: UIWebView!
    
    //MARK: - IBActions
    @IBAction func showDataFromUrlACTION(_ sender: Any) {
        //downloadSync()
        //downloadAsync()
        downloadAsyncPlus()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //MARK: - Utils
    func downloadSync(){
        
        do{
            let urlDataImage = try Data(contentsOf: URL(string: sImageUrl)!)
            myImageViewCustom.image = UIImage(data: urlDataImage)
            
            let urlDataWeb = URLRequest(url: URL(string: sWebUrl)!)
            myWebViewCustom.loadRequest(urlDataWeb)
        }catch let error{
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func downloadAsync(){
        //Cola 2 plano
        DispatchQueue.global(qos: .default).async {
            do{
                //Imagen
                let urlImagenData = try Data(contentsOf: URL(string: self.sImageUrl)!)
                let urlWebData = URLRequest(url: URL(string: self.sWebUrl)!)
                //Cola 1 plano
                DispatchQueue.main.async {
                    self.myImageViewCustom.image = UIImage(data: urlImagenData)
                }
                DispatchQueue.main.async {
                    self.myWebViewCustom.loadRequest(urlWebData)
                }
            }catch{
                print("Error al descargar datos")
            }
        }
    }
    
    func downloadAsyncPlus(){
        
        downloadImageWebfromData(callbackImage: { (imageData) in
            self.myImageViewCustom.image = imageData
        }) { (requestData) in
            self.myWebViewCustom.loadRequest(requestData)
        }
        
        
    }
    
    func downloadImageWebfromData(callbackImage : @escaping callBackImageData, callbackWeb : @escaping callBackWebdata){
        //Cola 2 plano
        DispatchQueue.global(qos: .default).async {
            do{
                let imageData = UIImage(data: try Data(contentsOf: URL(string: self.sImageUrl)!))
                let webData = URLRequest(url: URL(string: self.sWebUrl)!)
                //Cola 1 plano
                DispatchQueue.main.async {
                    callbackImage(imageData!)
                }
                DispatchQueue.main.async {
                    callbackWeb(webData)
                }
            }catch{
                print("Error al descargar los datos")
            }
        }
    }
    

    
    
    
    
    
    
    
    
    
    
    
    
    
}
