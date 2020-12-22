//
//  ViewController.swift
//  Agenda
//
//  Created by Maria Laura on 18/12/20.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var context : NSManagedObjectContext!
    var evento : NSManagedObject!

    @IBOutlet weak var dataEditText: UITextField!
    @IBOutlet weak var horaEditText: UITextField!
    @IBOutlet weak var tituloEditText: UITextField!
    @IBOutlet weak var descricaoEditText: UITextField!
        
    @IBAction func salvar(_ sender: Any) {
        if evento == nil {
            self.salvarEventos()
        }else{
            self.atualizarEventos()
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataEditText.becomeFirstResponder()
        self.horaEditText.becomeFirstResponder()
        self.tituloEditText.becomeFirstResponder()
        self.descricaoEditText.becomeFirstResponder()
        
        if evento != nil {
            if let horaRecuperada = evento.value(forKey: "hora"){
                self.horaEditText.text = String(describing: horaRecuperada)
            }
        }else{
            self.horaEditText.text = ""
        }
        
        if evento != nil {
            if let dataRecuperada = evento.value(forKey: "data"){
                self.dataEditText.text = String(describing: dataRecuperada)
            }
        }else{
            self.dataEditText.text = ""
        }
        
        if evento != nil {
            if let tituloRecuperado = evento.value(forKey: "titulo"){
                self.tituloEditText.text = String(describing: tituloRecuperado)
            }
        }else{
            self.tituloEditText.text = ""
        }
        
        if evento != nil {
            if let descricaoRecuperada = evento.value(forKey: "descricao"){
                self.descricaoEditText.text = String(describing: descricaoRecuperada)
            }
        }else{
            self.descricaoEditText.text = ""
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
    }
    
    func salvarEventos(){
        let novoEvento = NSEntityDescription.insertNewObject(forEntityName: "Eventos", into: context)
        
        novoEvento.setValue(self.dataEditText.text, forKey: "data")
        novoEvento.setValue(self.horaEditText.text, forKey: "hora")
        novoEvento.setValue(self.tituloEditText.text, forKey: "titulo")
        novoEvento.setValue(self.descricaoEditText.text, forKey: "descricao")
        
        do {
            try context.save()
            print("Evento cadastrado com sucesso!")
        } catch let erro {
            print("Erro ao cadastrar evento: \(erro.localizedDescription)")
        }
        
    }
    
    func atualizarEventos(){
        evento.setValue(self.dataEditText.text, forKey: "data")
        evento.setValue(self.horaEditText.text, forKey: "hora")
        evento.setValue(self.tituloEditText.text, forKey: "titulo")
        evento.setValue(self.descricaoEditText.text, forKey: "descricao")
        
        do {
            try context.save()
            print("Sucesso ao atualizar evento!")
        } catch let erro {
            print("Erro ao alterar o evento: \(erro.localizedDescription)")
        }
        
    }
}

