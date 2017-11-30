//
//  CaptureSessionController.swift
//  YEAH Control Scanner
//
//  Created by Desarrollo Adagal on 30/11/17.
//  Copyright © 2017 Desarrollo Adagal. All rights reserved.
//

import UIKit
import AVFoundation

class CaptureSessionController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var video = AVCaptureVideoPreviewLayer()
    let session: AVCaptureSession = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Creando sesion de captura de vídeo
        // session = AVCaptureSession()
        // PAra capturar necesitamos el dispositivo
        let captureDevice =  AVCaptureDevice.default(for: AVMediaType.video)
        
        // Vamos a comenzar la captura, así que inentamos recoger errores
        do {
            let  input = try AVCaptureDeviceInput(device: captureDevice!)   // Configuramos de dónde saldrá la entrada de vídeo
            session.addInput(input)  // Agregamos la entrada de vídeo a la sesión de captura
        } catch {
            //
            print("Error agregando la entrada de Vídeo")
            return
        }
        
        let output = AVCaptureMetadataOutput()  // Creamos una salida de metadatos
        session.addOutput(output)               // Añadimos la salida a la sesión
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)  // Configuramos la cola de objetos
        output.metadataObjectTypes = [.qr, .face]      // Tipo de objectos de meta datos que buscará
        video = AVCaptureVideoPreviewLayer(session: session)    // Asignamos la sesión al vídeo
        video.frame = view.layer.bounds         // Asignamos la captura de b¡vídeo al ancho de la pantalla
        view.layer.addSublayer(video)           // Añadimos la capa de video a la vista actual
        //Hemos configurado el dispositivo (la camara), la entrada (video), la salida (metadatos QR)
        // y la vista para agregarle la capa que captura el vídeo
        // Solo queda inicializar la captura
        session.startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects != nil && metadataObjects.count != 0 {
            let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject
            if object != nil {
                //
                if object?.type == AVMetadataObject.ObjectType.qr {
                    if let stringValueObtained = object?.stringValue {
                        // send it to server
                        session.stopRunning()
                        sendQRCodeToApiServer(stringValueObtained: stringValueObtained)
                    }
                } else if object?.type == AVMetadataObject.ObjectType.face {
                    print("face detected")
                }
            }
        }
        
    }
    
    func sendQRCodeToApiServer(stringValueObtained: String) {
        ApiRestService.doHttpPostRequest(qrCodeStringValue: stringValueObtained)
    }
    
    
}
