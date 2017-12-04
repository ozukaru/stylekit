//
//  UpdateView.swift
//
//  Created by Oz Zuñiga on 16/11/17.
//  Copyright © 2017 Oz Zuñiga. All rights reserved.
//
// Llamar clase checkVersion(urlComprobacion:URL) en AppDelegate dentro la función didFinishLaunchingWithOptions
// donde urlComprobacion es a donde se mandaran los datos (nombre, version y tipo) para verificar la versión de la app

import UIKit

class update:  UIViewController{
    
    var url = String()
   
    //COMPROBAR VERSIÓN:-----------------------------------------------------
    func checkVersion(urlComprobacion:URL){
        if let appName = Bundle.main.infoDictionary!["CFBundleName"] as? String{print("NOMBRE: \(appName)")//nombre de la app
            if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {print("VERSION: \(appVersion)")//version de la app
                
                let request = NSMutableURLRequest(url:urlComprobacion)
                request.httpMethod = "POST"
                request.httpBody = ("nombre=\(appName)&version=\(appVersion)&tipo=ios").data(using: String.Encoding.utf8)
                let task = URLSession.shared.dataTask(with: request as URLRequest) { (data,response,error) in
                    if error != nil{ print("error=\(String(describing: error))");return}
                    
                    if let jsonString = try? JSONSerialization.jsonObject(with: data!, options: []) as! [String: String]{//JSONSerialization de lo que responde el script a donde se mandan los datos
                        self.url = jsonString ["url"]!
                        if jsonString ["version"] != appVersion{
                            
                            print("Hay una Nueva Versión: \(jsonString ["version"]!)")
                            print("URL descarga: \(self.url)")
                            DispatchQueue.main.sync {//launch class update:  UIViewController con self
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.window!.rootViewController = self
                            appDelegate.window!.makeKeyAndVisible()
                            }
                            
                        }
                        else{print("Actualizada")}
                    }}
                task.resume()
            }}
    }
    
    
    
    
    //Vista Actualizar:--------------------------------------------------------------------------
    
    var img = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        
        //Hacer Boton Actualizar:--------------------------------------------------------------------------
        let width = UIScreen.main.applicationFrame.size.width
        let height = UIScreen.main.applicationFrame.size.height
        let actualizarButton = UIButton(frame: CGRect(x: 8, y: view.frame.maxY - 90, width: width - 16, height: 50))
        actualizarButton.backgroundColor = UIColor(red:0.086 ,green:0.502 ,blue:0.980 ,alpha: 1)
        actualizarButton.setTitle("Actualizar", for: .normal)
        actualizarButton.layer.cornerRadius = 12
        actualizarButton.clipsToBounds = true
        actualizarButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.backgroundColor = .white
        self.view.addSubview(actualizarButton)
       
        
        //Label:----------------------------------------------------------------
         let label = UILabel(frame: CGRect(x: 50, y: 50, width: width - 16, height: 40))
         label.center = CGPoint(x: w / 2, y: h / 2.5)
         label.textAlignment = .center
         label.textColor = UIColor(displayP3Red: 0.098, green: 0.102, blue: 0.106, alpha: 1)
         label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
         label.text = "Hay una nueva Actualización"
         self.view.addSubview(label)
        
        //Label2:--------------------------------------------------------------
        let label2 = UILabel(frame: CGRect(x: 50, y: 50, width: width - 16, height: 200))
        label2.center = CGPoint(x: w / 2, y: h / 2)
        label2.textAlignment = .center
        label2.font = UIFont(name: "Helvetica", size: 15)
        label2.numberOfLines = 10
        label2.textColor = UIColor(displayP3Red: 0.451, green: 0.451, blue: 0.451, alpha: 1)
        label2.text = "Actualizamos nuestras aplicaciones constantemente para ofrescerte un mejor producto."
        self.view.addSubview(label2)
        
        //Imagen:--------------------------------------------------
        let image = getAppIcon()
        let imageView = UIImageView(image: image)
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
        imageView.frame = CGRect(x: view.frame.maxX / 3, y: view.frame.minY + 90, width: 120, height: 120)
        imageView.center = CGPoint(x: w / 2, y: h / 4.5)
        view.addSubview(imageView)
        
        
        
        //Bton omitir:-----------------------------------------------------------------
        /*
        let omitirButton = UIButton(frame: CGRect(x: 8, y: view.frame.maxY - 50, width: width - 16, height: 50))
       // omitirButton.backgroundColor = UIColor(red:0.086 ,green:0.502 ,blue:0.980 ,alpha: 1)
        omitirButton.setTitle("Omitir", for: .normal)
        omitirButton.setTitleColor(UIColor.gray, for: UIControlState.normal)
       // omitirButton.layer.cornerRadius = 12
        omitirButton.clipsToBounds = true
        omitirButton.addTarget(self, action: #selector(omitir), for: .touchUpInside)
        self.view.addSubview(omitirButton)*/
        
        
    }
    
    
  //Accion Boton Actualizar:--------------------------------------------------------------------------
    @objc func buttonAction(sender: UIButton!) {
        print("Actualizar")
        let GoURL = URL(string: self.url)
        print("GOURL \(GoURL!)")
        if UIApplication.shared.canOpenURL(GoURL!) {
            UIApplication.shared.open(GoURL!, options: [:], completionHandler: { (success) in
                print("Open url : \(success)")
            })}
     }
    
    //Accion Boton omitir:--------------------------------------------------------------------------
    /*
    @objc func omitir(sender: UIButton!) {
      
        DispatchQueue.main.sync {//launch class update:  UIViewController con self
           self.present(vc, animated: true, completion: nil)
        }
        
    }*/
    
    //obtener icono de la app:--------------------------------------------------------------------------------
    func getAppIcon() -> UIImage {
        let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? NSDictionary
        let primaryIconsDictionary = iconsDictionary?["CFBundlePrimaryIcon"] as? NSDictionary
        let iconFiles = primaryIconsDictionary!["CFBundleIconFiles"] as! NSArray
        // First will be smallest for the device class, last will be the largest for device class
        let lastIcon = iconFiles.lastObject as! NSString
        let icon = UIImage(named: lastIcon as String)
        return icon!
      }
 
}

