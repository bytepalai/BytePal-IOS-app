//
//  ViewController.swift
//  BytePal
//
//  Created by may on 5/30/20.
//  Copyright © 2020 BytePal-AI. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Foundation

class ViewController: UIViewController {
//  Text field variables
    private var message: String = ""
    
//  Top bar (user information) (view container)
    private let userBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray2
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.red.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //  User icon in userBar view container
    private let userIcon: UIImageView = {
        var icon = UIImage(systemName: "person.crop.circle")
        let iconView = UIImageView(image: icon)
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        return iconView
    }()
    
    //  Message History
    private let messageHistory: UIView = {
        let view = UIView()
//        view.layer.borderWidth = 5
//        view.layer.borderColor = UIColor.green.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let messages: UITableView = {
        let tableView = UITableView()
//        tableView.backgroundColor = UIColor.yellow
        tableView.layer.masksToBounds = true
        tableView.layer.borderWidth = 5
        tableView.layer.borderColor = UIColor.yellow.cgColor
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

//  Bottom bar for messaging (view container)
    private let messageBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray2
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.blue.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//  text entry field in messageBar view controller
    private let messageField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
//  button to send message in messageBar view controller
    let sendMessageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("send", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(sendPOST), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.layer.borderWidth = 5
        v.layer.borderColor = UIColor.yellow.cgColor
        v.translatesAutoresizingMaskIntoConstraints = false
//        v.backgroundColor = .cyan
        return v
    }()
    
//  send POST request function
    @objc func sendPOST(sender: UIButton!){
        let semaphore = DispatchSemaphore (value: 0)
        let message: String = self.messageField.text!

        let parameters = "message=\(message)"
        let postData =  parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://webhook.site/50f0bd2b-a90b-4a2a-aef0-c1470e958a60")!,timeoutInterval: Double.infinity)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("laravel_session=f0ExDqncinbVTJN7TxwaorAJBnK1ZstwmYglm7Ui", forHTTPHeaderField: "Cookie")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
          semaphore.signal()
        }
        
        characters.append(message)
        
        let indexPath = IndexPath(row: characters.count - 1, section: 0)
        
        messages.beginUpdates()
        messages.insertRows(at: [indexPath], with: .automatic)
        messages.endUpdates()
        print(characters)

        task.resume()
        semaphore.wait()
    }
    
    var characters = ["apple", "banana", "canteloup", "durian"]

    //  Render Screen and define styling of components
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayoutManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)

//            let blue = UIColor(red: 20/255, green: 126/255, blue: 251/255, alpha: 1)

    //        showOutgoingMessage(color: blue, text: "An arbitrary text which we use to demonstrate how our label sizes' calculation works.")
    //        showOutgoingMessage(color: blue, text: "ALAE")
    }
    
    func setupLayoutManager(){
        view.backgroundColor = .white
        
//        messages.dataSource = self
//        messages.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let safeArea = view.layoutMarginsGuide

        view.addSubview(userBar)
        view.addSubview(scrollView)
//        view.addSubview(messageHistory)
        view.addSubview(messageBar)
        
        userBar.addSubview(userIcon)
//        messageHistory.addSubview(messages)
        messageBar.addSubview(messageField)
        messageBar.addSubview(sendMessageButton)
        
//        scrollView.addSubview(showOutgoingMessage(color: UIColor.systemBlue, text: "Hello"))
//        scrollView.addSubview(showOutgoingMessage(color: UIColor.systemBlue, text: "Hello"))
//        scrollView.addSubview(showOutgoingMessage(color: UIColor.systemBlue, text: "Hello"))
        
        NSLayoutConstraint.activate([
            userBar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            userBar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            userBar.topAnchor.constraint(equalTo: safeArea.topAnchor),
            userBar.heightAnchor.constraint(equalToConstant: userIcon.intrinsicContentSize.height + 32)
        ])
        NSLayoutConstraint.activate([
            userIcon.centerXAnchor.constraint(equalTo: userBar.centerXAnchor),
            userIcon.centerYAnchor.constraint(equalTo: userBar.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: userBar.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: messageBar.topAnchor)
        ])
        
        
        NSLayoutConstraint.activate([
            messageBar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            messageBar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            messageBar.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            messageBar.heightAnchor.constraint(equalToConstant: sendMessageButton.intrinsicContentSize.height + 32)
        ])
        NSLayoutConstraint.activate([
            messageField.leadingAnchor.constraint(equalTo: messageBar.leadingAnchor, constant: 16),
            messageField.trailingAnchor.constraint(equalTo: sendMessageButton.leadingAnchor, constant: -16),
            messageField.centerYAnchor.constraint(equalTo: messageBar.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            sendMessageButton.trailingAnchor.constraint(equalTo: messageBar.trailingAnchor, constant: -16),
            sendMessageButton.centerYAnchor.constraint(equalTo: messageBar.centerYAnchor)
        ])
        sendMessageButton.contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        
        
//        NSLayoutConstraint.activate([
//            messageHistory.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
//            messageHistory.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
//            messageHistory.topAnchor.constraint(equalTo: userBar.bottomAnchor),
//            messageHistory.bottomAnchor.constraint(equalTo: messageBar.topAnchor)
//        ])
//
//        messages.leadingAnchor.constraint(equalTo: messageHistory.leadingAnchor).isActive = true
//        messages.trailingAnchor.constraint(equalTo: messageHistory.trailingAnchor).isActive = true
//        messages.topAnchor.constraint(equalTo:  messageHistory.topAnchor).isActive = true
//        messages.bottomAnchor.constraint(equalTo: messageHistory.bottomAnchor).isActive = true
//
        
        //        let loginButton = FBLoginButton()
        //        loginButton.center = view.center
        //        view.addSubview(loginButton)
        //
        //        NotificationCenter.default.addObserver(forName: .AccessTokenDidChange, object: nil, queue: OperationQueue.main) { (notification) in
        //
        //            // Print out access token
        //            print("FB Access Token: \(String(describing: AccessToken.current?.tokenString))")
        //        }
    }

//    func showOutgoingMessage(color: UIColor, text: String) -> UIView {
//        let label =  UILabel()
//        label.numberOfLines = 0
//        label.font = UIFont.systemFont(ofSize: 18)
//        label.textColor = .white
//        label.text = text
//
//        let constraintRect = CGSize(width: 0.66 * view.frame.width,
//                                    height: .greatestFiniteMagnitude)
//        let boundingBox = text.boundingRect(with: constraintRect,
//                                            options: .usesLineFragmentOrigin,
//                                            attributes: [.font: label.font],
//                                            context: nil)
//        label.frame.size = CGSize(width: ceil(boundingBox.width),
//                                  height: ceil(boundingBox.height))
//
//        let bubbleImageSize = CGSize(width: label.frame.width + 28,
//                                     height: label.frame.height + 20)
//
//        let outgoingMessageView = UIImageView(frame:
//            CGRect(x: view.frame.width - bubbleImageSize.width - 20,
//                   y: view.frame.height - bubbleImageSize.height - 86,
//                   width: bubbleImageSize.width,
//                   height: bubbleImageSize.height))
//
//        let bubbleImage = UIImage(named: "outgoing-message-bubble")?
//            .resizableImage(withCapInsets: UIEdgeInsets(top: 17, left: 21, bottom: 17, right: 21),
//                            resizingMode: .stretch)
//            .withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
//
//        outgoingMessageView.image = bubbleImage
//        outgoingMessageView.tintColor = color
//
//        let view = UIView()
//
//        view.addSubview(outgoingMessageView)
//
//        label.center = outgoingMessageView.center
//
//        view.addSubview(label)
//        return view
//    }
    
}

//extension ViewController: UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return characters.count
//    }
//
////    message cell configuration
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        //        Label
//        let label =  UILabel()
//        label.numberOfLines = 0
//        label.font = UIFont.systemFont(ofSize: 18)
//        label.textColor = .white
//        let text = characters[indexPath.row]
//        label.text = text
//        label.translatesAutoresizingMaskIntoConstraints = false
//
//        let constraintRect = CGSize(width: 0.66 * view.frame.width,
//                                    height: .greatestFiniteMagnitude)
//        let boundingBox = text.boundingRect(with: constraintRect,
//                                            options: .usesLineFragmentOrigin,
//                                            attributes: [.font: label.font],
//                                            context: nil)
//        label.frame.size = CGSize(width: ceil(boundingBox.width),
//                                  height: ceil(boundingBox.height))
//
//        let bubbleImageSize = CGSize(width: label.frame.width + 28,
//                                     height: label.frame.height + 20)
//
//        let outgoingMessageView = UIImageView(frame:
//            CGRect(x: messageHistory.frame.width - bubbleImageSize.width - 20,
//                   y: messageHistory.frame.height - bubbleImageSize.height - 86,
//                   width: bubbleImageSize.width,
//                   height: bubbleImageSize.height))
//
//        let bubbleImage = UIImage(named: "outgoing-message-bubble")?
//            .resizableImage(withCapInsets: UIEdgeInsets(top: 17, left: 21, bottom: 17, right: 21),
//                            resizingMode: .stretch)
//            .withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
//
//        let blue = UIColor(red: 20/255, green: 126/255, blue: 251/255, alpha: 1)
//        outgoingMessageView.image = bubbleImage
//        outgoingMessageView.tintColor = blue
//
//        label.center = outgoingMessageView.center
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        print(characters[indexPath.row])
//
//        cell.selectionStyle = .none
//        cell.contentView.addSubview(outgoingMessageView)
//        cell.contentView.addSubview(label)
//        return cell
//    }
//}
