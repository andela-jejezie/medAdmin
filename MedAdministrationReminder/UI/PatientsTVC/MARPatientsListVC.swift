//
//  MARPatientsListVC.swift
//  MedAdministrationReminder
//
//  Created by Andela on 5/29/16.
//  Copyright © 2016 Andela. All rights reserved.
//

import UIKit
import CoreData

private let patientCellIdentifier = "MARPatientsListTableViewCell"

class MARPatientsListVC: MARGenericVC {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var fetchedResultsController: NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Patients"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let fetchRequest = NSFetchRequest(entityName: "Patient")
        fetchRequest.sortDescriptors = [nameSortDescriptor]
        fetchRequest.predicate = NSPredicate(format:"nurse == %@", self.currentUser!)
        fetchedResultsController =
            NSFetchedResultsController(fetchRequest: fetchRequest,
                                       managedObjectContext: coreDataHelper.context,
                                       sectionNameKeyPath: nil,
                                       cacheName: nil)
        
        
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    //MARK:- Configure Cell
    func configureCell(cell: MARPatientsListTableViewCell, indexPath: NSIndexPath) {
        let patient =
            fetchedResultsController.objectAtIndexPath(indexPath)
                as! Patient
        cell.patient = patient
    }
    
    @IBAction func onAddButtonTapped(sender: AnyObject) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let targetVC = mainStoryboard.instantiateViewControllerWithIdentifier("MARAddPatienVC") as! MARAddPatienVC
        targetVC.delegate = self
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    
    
    lazy var nameSortDescriptor: NSSortDescriptor = {
        var sd = NSSortDescriptor(key: "fullName",
                                  ascending: true,
                                  selector: #selector(NSString.localizedStandardCompare(_:)))
        return sd
    }()
}

extension MARPatientsListVC: UITableViewDataSource {
    
    func numberOfSectionsInTableView
        (tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }
    
    func tableView(tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        let sectionInfo =
            fetchedResultsController.sections![section]
        return sectionInfo.name
    }
    
    func tableView(tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        let sectionInfo =
            fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(tableView: UITableView,
                   cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            
            let cell =
                tableView.dequeueReusableCellWithIdentifier(
                    patientCellIdentifier, forIndexPath: indexPath)
                    as! MARPatientsListTableViewCell
            
            configureCell(cell, indexPath: indexPath)
            return cell
    }
}

extension MARPatientsListVC: UITableViewDelegate {
    
    func tableView(tableView: UITableView,
                   didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let patient = fetchedResultsController.objectAtIndexPath(indexPath) as! Patient
        let targetVC = self.storyboard?.instantiateViewControllerWithIdentifier(patientDetailVCIdentifier) as! MARPatientDetailVC
        targetVC.patient = patient
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
}

extension MARPatientsListVC: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(controller:
        NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController,
                    didChangeObject anObject: AnyObject,
                                    atIndexPath indexPath: NSIndexPath?,
                                                forChangeType type: NSFetchedResultsChangeType,
                                                              newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            self.tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .None)
        case .Move:
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controllerDidChangeContent(controller:
        NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController,
                    didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
                                     atIndex sectionIndex: Int,
                                             forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            return
        }
    }
    
}

extension MARPatientsListVC: addPatientVCDelegate {
    func addPatientVCDidAddPatient() {
        do {
            try fetchedResultsController.performFetch()
            self.tableView.reloadData()
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }
}
