//
//  ViewController.swift
//  Selfie Share
//
//  Created by Phat Nguyen on 06/01/2022.
//

/**
 * MultipeerConnectivity: Allow to link devices
 */

import UIKit
import MultipeerConnectivity

class ViewController: UICollectionViewController  {
    
    var images = [UIImage]()
    
    // MultipeerConnectivity
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    var mcSession: MCSession?
    var mcAdvertiserAssistant: MCAdvertiserAssistant?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Selfie Share"
        
        navigationBar()
    }
    
    func navigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
    }
    
    func setupMultiPeer() {
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
    }
    
    func startHosting(action: UIAlertAction) {
        guard let mcSession = mcSession else {
            return
        }
        
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-PN", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant?.start()  // start socket
    }
    
    func joinSession(action: UIAlertAction) {
        /**
         The MCBrowserViewController class presents nearby devices to the user and enables the user to invite nearby devices to a session. To use this class in iOS or tvOS, call methods from the underlying UIViewController class (prepare(for:sender:) and performSegue(withIdentifier:sender:) for storyboards or present(_:animated:completion:) and dismiss(animated:completion:) for nib-based views) to present and dismiss the view controller. In macOS, use the comparable NSViewController methods presentAsSheet(_:) and dismiss(_:) instead.
         */
        
        guard let mcSession = mcSession else {
            return
        }
        
        let mcBrowser = MCBrowserViewController(serviceType: "hws-PN", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    @objc func showConnectionPrompt() {
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
}

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
        
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.row]
        }
        
        return cell
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        
        images.insert(image, at: 0)
        collectionView.reloadData()
        
        // create new session
        
        /**
          1 Check if we have an active session we can use.
          2 Check if there are any peers to send to.
          3 Convert the new image to a Data object.
          4 Send it to all peers, ensuring it gets delivered.
          5 Show an error message if there's a problem.
         */
        guard let mcSession = mcSession else { return }
        if mcSession.connectedPeers.count > 0 {
            if let imageData = image.pngData() {
                do {
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
                }
                catch {
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    present(ac, animated: true)
                }
            }
        }
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension ViewController: MCSessionDelegate, MCBrowserViewControllerDelegate{
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        //
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        // empty now
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        // empty now
    }
    
    // Session delegate
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected \(peerID.displayName)")
        case .connecting:
            print("Connecting \(peerID.displayName)")
        case .notConnected:
            print("Not Connected \(peerID.displayName)")
        @unknown default:
            print("Unknown \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            [weak self] in
            guard let strongSelf = self else { return }
            
            if let image = UIImage(data: data) {
                strongSelf.images.insert(image, at: 0)
                strongSelf.collectionView.reloadData()
            }
        }
    }
    
    // Browser Deleagate
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
}
