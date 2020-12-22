//
//  ListarAgendaTableViewController.swift
//  Agenda
//
//  Created by Maria Laura on 18/12/20.
//

import UIKit
import CoreData

class ListarAgendaTableViewController: UITableViewController {
    
    var context : NSManagedObjectContext!
    var eventos : [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getEventos()
    }
    
    func getEventos(){
        
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "Eventos")
        let ordenacao = NSSortDescriptor(key: "data", ascending: true)
        
        requisicao.sortDescriptors = [ordenacao]
        
        do {
            
            let eventosRecuperados = try context.fetch(requisicao)
            self.eventos = eventosRecuperados as! [NSManagedObject]
            self.tableView.reloadData()
            
            print("Carregou um total de \(eventos.count)")
            
            
        } catch let erro  {
            print("Erro ao recuperar os eventos: \(erro.localizedDescription)")
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "AgendaCell", bundle: nil), forCellReuseIdentifier: "celula")
        let cell = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath) as! EventoTableViewCell

        let evento = self.eventos[indexPath.row]
        let titulo = evento.value(forKey: "titulo")
        let data = evento.value(forKey: "data")
        let descricao = evento.value(forKey: "descricao")
        let hora = evento.value(forKey: "hora")
                
        
        //let dataFormatada = DateFormatter()
        //dataFormatada.dateFormat="dd/MM/yyyy"
        
       // let novaData = dataFormatada.string(from: data as! Date)

        //cell.textLabel?.text = titulo as? String
        //cell.detailTextLabel?.text = String(describing: data)
        
        //cell.dataEditText?.text = data as? String
        
        cell.dataLabel?.text = data as? String
        cell.horaLabel?.text = hora as? String
        cell.tituloLabel?.text = titulo as? String
        cell.descricaoLabel?.text = descricao as? String
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let evento = self.eventos[indexPath.row]
        
        self.performSegue(withIdentifier: "verEvento", sender: evento)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let evento = self.eventos[indexPath.row]
            
            self.context.delete(evento)
            
            self.eventos.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            do {
                try self.context.save()
            } catch let erro {
                print("Erro ao remover evento \(erro.localizedDescription)")
            }
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "verEvento"{
            let viewDestino = segue.destination as! ViewController
            
            viewDestino.evento = sender as? NSManagedObject
        }
    }
    

}
