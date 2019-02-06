//
//  TabelViewController.swift
//  MultipleDownloadSample
//
//  Created by CompIndia on 28/12/18.
//  Copyright © 2018 joprithivi. All rights reserved.
//

import UIKit


class TabelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate, URLSessionDownloadDelegate {

    @IBOutlet weak var downloadTaskTable: UITableView!
    var downloadTaskList: [String]? = []
    var indexPathValue = IndexPath()
    
    private let byteFormatter: ByteCountFormatter = {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB]
        return formatter
    }()

    let urlStrings = [
        "https://images.apple.com/v/imac-with-retina/a/images/overview/5k_image.jpg",
        "https://photojournal.jpl.nasa.gov/jpeg/PIA08506.jpg",
        "http://placehold.it/120x120&text=image3",
        "http://placehold.it/120x120&text=image4"
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urlStrings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:DownloadTaskCell? = tableView.dequeueReusableCell(withIdentifier: "DownloadTaskCell") as? DownloadTaskCell
        if(cell == nil) {
            cell = DownloadTaskCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "DownloadTaskCell");
        }
        
        cell!.layoutMargins = UIEdgeInsets.zero
        cell!.preservesSuperviewLayoutMargins = false
        
        cell!.name.text = urlStrings[indexPath.row]
        cell!.progressLbl.text = "0%"
        cell!.progressBar.progress = 0.0
        let urls = urlStrings.map { URL(string: $0)! }
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // lets create your destination file url
        let destinationUrl = documentsDirectoryURL.appendingPathComponent(urls[indexPath.row].lastPathComponent)
        print(destinationUrl)
        // to check if it exists before downloading it
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            print("The file already exists at path")
            // if the file doesn't exist
        } else {
            indexPathValue = indexPath
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
            // Don't specify a completion handler here or the delegate won't be called
            session.downloadTask(with: urls[indexPath.row]).resume()
        }
        return cell!
    }

    //delegates1 : thats code
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let written = byteFormatter.string(fromByteCount: totalBytesWritten)
        let expected = byteFormatter.string(fromByteCount: totalBytesExpectedToWrite)
        print("Downloaded \(written) / \(expected)")
        let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)
        DispatchQueue.main.async {
            if let trackCell = self.downloadTaskTable.cellForRow(at: IndexPath(row: self.indexPathValue.row,section: 0)) as? DownloadTaskCell {
                trackCell.updateDisplay(progress: Float(totalBytesWritten) / Float(totalBytesExpectedToWrite), totalSize: totalSize)
            }
            //self.progressView.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            print(Float(totalBytesWritten) / Float(totalBytesExpectedToWrite))
            
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        // The location is only temporary. You need to read it or copy it to your container before
        // exiting this function. UIImage(contentsOfFile: ) seems to load the image lazily. NSData
        // does it right away.
        let downloadURL = downloadTask.currentRequest!.url! as URL
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // lets create your destination file url
        let destinationUrl = documentsDirectoryURL.appendingPathComponent(downloadURL.lastPathComponent)
        print(destinationUrl)
        print(location)
        
        //guard let data = try? Data(contentsOf: location), let image = UIImage(data: data) else { return }
        guard (try? Data(contentsOf: location)) != nil else { return }
        do {
            // after downloading your file you need to move it to your destination url
            try FileManager.default.moveItem(at: location, to: destinationUrl)
            print("File moved to documents folder")
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
