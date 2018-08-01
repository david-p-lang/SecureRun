//
//  ResultsViewController.swift
//  Secure Run
//
//  Created by David Lang on 7/27/18.
//  Copyright © 2018 David Lang. All rights reserved.
//

import UIKit
import CoreData

class ResultsViewController: UITableViewController {

    private var runs: [Run?] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first)")

        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest = Run.fetchRequest()
        
        do {
            runs = try managedContext.fetch(fetchRequest)
            runs = runs.reversed()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

        // Do any additional setup after loading the view.
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return runs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ResultsViewCell = tableView.dequeueReusableCell(withIdentifier: "RunDataCell", for: indexPath) as! ResultsViewCell
        
        let dateTxt = FormatDisplay.date(runs[indexPath.row]?.timestamp)
        cell.date.text = "Date: " + dateTxt
        cell.distance.text = "Distance: " + FormatDisplay.distance((runs[indexPath.row]?.distance)!)
        print("results view : \(runs[indexPath.row]?.distance)")
        print("\(FormatDisplay.distance((runs[indexPath.row]?.distance)!))")
        cell.time.text = "Duration: " + FormatDisplay.time((Int(runs[indexPath.row]!.duration)))
        //cell.calories?.text = "Calories:"
        cell.maximumPace.text = "Pace:"

        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

}
