//
//  ApiRestService.swift
//  YEAH Control Scanner
//
//  Created by Desarrollo Adagal on 29/11/17.
//  Copyright © 2017 Desarrollo Adagal. All rights reserved.
//

import Foundation

infix operator >>>=

class ApiRestService {
    private static func apiEndpoint() -> String{
        // return "https://yeahcontrol.es/api"
        return "https://jsonplaceholder.typicode.com"
    }
    private static func apiVersion() -> String {
        // return "/v1"
        return ""
    }
    
    static func doHttpGetRequest() {
        //
    }
    
    struct respuesta {
        let acceso: String
    }
    
    static func doHttpPostRequest(qrCodeStringValue: String){
        // Construimos la url
        // guard let url = URL(string: apiEndpoint()+apiVersion()+"/queryPerson") else {
        guard let url = URL(string: apiEndpoint()+apiVersion()+"/posts") else {
            print("Error: cannot create URL")
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        // Generamos los datos
        let newPerson: [String: Any] = ["person": qrCodeStringValue]
        let jsonPerson: Data
        do {
            
            jsonPerson = try JSONSerialization.data(withJSONObject: newPerson, options: [])
            urlRequest.httpBody = jsonPerson
        } catch {
            print("Error: cannot create JSON from QR Code data")
            return
        }
        let session = URLSession.shared
        // Data?, URLResponse?, Error?
        let task = session.dataTask(with: urlRequest, completionHandler: {(data, response, error) -> Void in
            guard let data = data else {
                print("Petición HTTP fallida \(error)")
                return
            }
            
            print("Respuesta del servidor")
            do {
                // Serializamos el objeto data en un diccionario de strings
                print("Response")
                print(response)
                print("Data")
                print(data)
                print("Error")
                print(error)
            } catch let error as NSError {
                print("Error procesando los datos: \(error)")
            }
        })
        task.resume()       // Enviamos la petición
    }
}
