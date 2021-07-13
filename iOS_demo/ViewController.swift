//
//  ViewController.swift
//  apple-p2p-engine
//
//  Created by Timmy on 2021/6/21.
//

import UIKit
import SnapKit
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "normalCell")
        if (indexPath.row == 0) {
            cell.textLabel?.text = "Video Stream P2P"
        } else if (indexPath.row == 1) {
            cell.textLabel?.text = "File Download P2P"
        }
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (indexPath.row == 0) {
            let destination = VideoViewController()
    //        destination.message = "传递的字符串"
            self.present(destination, animated: true, completion: nil)
        } else if (indexPath.row == 1) {
            let alertController = UIAlertController(title: "Notice", message: "Download P2P is not available now", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    lazy var table:UITableView = {
        let table = UITableView(frame: CGRect(x: 0, y: 60, width: self.view.bounds.width, height: 120), style: UITableView.Style.plain)
        return table
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
                
        self.view.addSubview(table)
        table.delegate = self
        table.dataSource = self
        
        let label:UILabel = UILabel()
        label.text = "1. Please run on real device\n\n2. Open same video on 2 devices to check p2p performance"
        label.textColor = .red
        label.textAlignment = .left

        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        //设置文本高亮
        label.isHighlighted = true
        self.view.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(200)
            make.height.equalTo(160)
        }
        
        // Do any additional setup after loading the view.
    }

    
}

