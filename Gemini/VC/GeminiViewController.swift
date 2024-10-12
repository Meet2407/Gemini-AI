import UIKit

class GeminiViewController: UIViewController {
    
    var geminiDtl = GeminiViewModel()
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textFeild: UITextField!
    @IBOutlet weak var geminiTbl: UITableView!
    
    var data: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendButton.layer.cornerRadius = 5
        sendButton.layer.masksToBounds = true
        geminiTbl.rowHeight = UITableView.automaticDimension
        geminiTbl.estimatedRowHeight = 125
        sendButton.addTarget(self, action: #selector(sendButtonClicked), for: .touchUpInside)
        hideKeyboardWhenTappedAround()
    }
    
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    @IBAction func sendButtonClicked(_ sender: Any) {
        guard let userInput = textFeild.text, !userInput.isEmpty else {
            print("Please enter some text")
            return
        }
        data.append("You: \(userInput)")
        geminiDtl.geminiDataFatch(inputText: userInput, success: {
            DispatchQueue.main.async {
                if let aiResponse = self.geminiDtl.ans {
                    self.data.append("AI:\n \(aiResponse)")
                }
                self.geminiTbl.reloadData()
                self.textFeild.text = ""
            }
        }, failure: { error in
            print("Failed to fetch data: \(error)")
        })
    }


}

extension GeminiViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.geminiTbl.dequeueReusableCell(withIdentifier: "GeminiTableViewCell") as! GeminiTableViewCell
        let conversationText = data[indexPath.row]
        
        if conversationText.hasPrefix("You:") {
            cell.geminiOne?.text = conversationText.replacingOccurrences(of: "You: ", with: "")
            cell.geminiOne.textColor = .white
            cell.bgview.backgroundColor = .red
            cell.bgview.layer.cornerRadius = 10
            cell.bgview.layer.masksToBounds = true
            cell.geminiOne.textAlignment = .right
            cell.bgview.isHidden = false
            cell.geminiOne.isHidden = false
        } else if conversationText.hasPrefix("AI:") {
    
            cell.geminiOne?.text = conversationText.replacingOccurrences(of: "AI:\n", with: "")
            cell.geminiOne.textColor = .black
            cell.bgview.backgroundColor = .blue
            cell.bgview.layer.cornerRadius = 10
            cell.bgview.layer.masksToBounds = true
            cell.geminiOne.textAlignment = .left
            cell.bgview.isHidden = false
            cell.geminiOne.isHidden = false
            cell.bgview.frame.origin.x = 16
            cell.geminiOne.frame.origin.x = 16
        }
        
        return cell
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
