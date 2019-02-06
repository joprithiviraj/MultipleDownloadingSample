//
//  ListViewController.swift
//  MultipleDownloadSample
//
//  Created by CompIndia on 28/12/18.
//  Copyright © 2018 joprithivi. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate, URLSessionDownloadDelegate {

    var getLinkArray = [String]()
    @IBOutlet weak var link1TextField: UITextField!
    @IBOutlet weak var link2TextField: UITextField!
    @IBOutlet weak var link3TextField: UITextField!
    
    
    //delegate1: that code
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    
    private let byteFormatter: ByteCountFormatter = {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB]
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        let urlStrings = [
//            "https://images.apple.com/v/imac-with-retina/a/images/overview/5k_image.jpg",
//            "https://photojournal.jpl.nasa.gov/jpeg/PIA08506.jpg",
//            "http://placehold.it/120x120&text=image3",
//            "http://placehold.it/120x120&text=image4"
//        ]
//        let urls = urlStrings.map { URL(string: $0)! }
//
//        for url in urls {
//            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//            // lets create your destination file url
//            let destinationUrl = documentsDirectoryURL.appendingPathComponent(url.lastPathComponent)
//            print(destinationUrl)
//            // to check if it exists before downloading it
//            if FileManager.default.fileExists(atPath: destinationUrl.path) {
//                print("The file already exists at path")
//                // if the file doesn't exist
//            } else {
//                let config = URLSessionConfiguration.default
//                let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
//                // Don't specify a completion handler here or the delegate won't be called
//                session.downloadTask(with: url).resume()
//            }
//        }
    }
    
    @IBAction func download(_ sender: Any) {
        self.performSegue(withIdentifier: "TableSegue", sender: nil)
        /*
        //this is for delegates methods and also downloading delegates1
        let url = URL(string: "https://photojournal.jpl.nasa.gov/jpeg/PIA08506.jpg")!
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        // Don't specify a completion handler here or the delegate won't be called
        session.downloadTask(with: url).resume()
        
         //Working fine for normal dowloading
        if let audioUrl = URL(string: "https://images.apple.com/v/imac-with-retina/a/images/overview/5k_image.jpg") {
            // then lets create your document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            print(destinationUrl)
            
            // to check if it exists before downloading it
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                print("The file already exists at path")
                // if the file doesn't exist
            } else {
                
                // you can use NSURLSession.sharedSession to download the data asynchronously
                URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
                    guard let location = location, error == nil else { return }
                    do {
                        // after downloading your file you need to move it to your destination url
                        try FileManager.default.moveItem(at: location, to: destinationUrl)
                        print("File moved to documents folder")
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }).resume()
            }
        }
 */
    }
    
    //delegates1 : thats code
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let written = byteFormatter.string(fromByteCount: totalBytesWritten)
        let expected = byteFormatter.string(fromByteCount: totalBytesExpectedToWrite)
        print("Downloaded \(written) / \(expected)")
        
        DispatchQueue.main.async {
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
        
        guard let data = try? Data(contentsOf: location), let _ = UIImage(data: data) else { return }
        do {
            // after downloading your file you need to move it to your destination url
            try FileManager.default.moveItem(at: location, to: destinationUrl)
            print("File moved to documents folder")
        } catch let error as NSError {
            print(error.localizedDescription)
        }

//        if let data = try? Data(contentsOf: location), let image = UIImage(data: data) {
//            DispatchQueue.main.async {
//
//                let downloadURL = downloadTask.currentRequest!.url!.absoluteString
//                downloadURL.lastPathComponent
//                self.imageView.contentMode = .scaleAspectFit
//                self.imageView.clipsToBounds = true
//                self.imageView.image = image
//            }
//        } else {
//            fatalError("Cannot load the image")
//        }
//
    }
    
    /*
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let downloadURL: NSString! = downloadTask.currentRequest!.url!.absoluteString as NSString
        print("downloadURL : %@",downloadURL)
        let data: NSMutableData = NSMutableData(contentsOf: location as URL)!
        
        DispatchQueue.main.sync(execute: {
            let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,.userDomainMask, true)
            let documentsDirectory: NSString! = paths[0] as NSString
            let getNameString: NSString! = NSString(format: "%@", downloadURL.lastPathComponent)
            let getImagePath: NSString! = documentsDirectory.appendingPathComponent(getNameString as String) as NSString
            let imageObj: UIImage! = UIImage(contentsOfFile:getImagePath as String)
            
            if (imageObj == nil) {
                DispatchQueue.main.async {
                    data.write(toFile: getImagePath as String, atomically:true)
                    print("File Saved!!!")
                }
            }
            else {
                print("File already saved!!!")
            }
        })
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        DispatchQueue.main.async {
            print("This is run on the main queue, after the previous code in outer block")
            // do some task
            if let deviceMemory = self.getFreeDiskspacePrivate() {
                let deviceMemory = (deviceMemory/1024/1024)
                print("free space: \(deviceMemory)")
                let progress = Float(totalBytesWritten / totalBytesExpectedToWrite)
                print("Making progress: \(progress)")
            } else {
                print("failed")
            }
            
            DispatchQueue.main.async {
                // update some UI
            }
        }
        
    }
    
    func getFreeDiskspacePrivate() -> Int64? {
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let systemAttributes = try! FileManager.default.attributesOfFileSystem(forPath: documentDirectoryPath.last! as String)
        let freeSize = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value
        print("%s - Free Diskspace: %u bytes - %u MiB", freeSize!, (freeSize!/1024/1024))
        return freeSize
    }
    */
    
    /*
    @IBAction func download(_ sender: Any) {
        
        let url = URL(string: "http://4.bp.blogspot.com/-oxlezteeOII/TfiTImj4RlI/AAAAAAAAA1k/UAgctmU5VZo/s1600/Widescreen+Unique+And+Beautiful+Photography+%25284%2529.jpg")!
        let task = URLSession.shared.downloadTask(with: url) { localURL, urlResponse, error in
            if let localURL = localURL {
                if let string = try? String(contentsOf: localURL) {
                    print(string)
                }
            }
        }
        task.resume()
        
        
        
//        if link1TextField.text!.isEmpty && link2TextField.text!.isEmpty && link3TextField.text!.isEmpty {
//            print("Please enter any one values")
//        }
//        else {
//            let linkArray = [link1TextField.text, link2TextField.text, link3TextField.text] as! [String]
//            print("get \(linkArray)")
//            getLinkArray = linkArray.filter { $0 != "" }
//            print("get \(getLinkArray)")
//            self.performSegue(withIdentifier: "TableSegue", sender: nil)
//        }
    }
 
 */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
