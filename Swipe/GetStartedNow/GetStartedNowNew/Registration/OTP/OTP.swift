import UIKit
import Alamofire
import CRNotifications

class OTP: UIViewController, UITextFieldDelegate {

    var getNumber: String!
    var getEmail: String!
    var otpFields: [UITextField] = []

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var topBlueView: UIView!   // The curve background

    override func viewDidLoad() {
        super.viewDidLoad()

        setupStaticUI()
        createOTPBoxes()
        generateOTP()
    }

    // MARK: - SETUP STATIC UI (Title, Subtitle)
    // MARK: - SETUP STATIC UI (Title, Subtitle)
    func setupStaticUI() {
        lblTitle.text = "Confirmation Code"

        var email = ""
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String: Any] {
            email = person["email"] as? String ?? ""
        }

        lblSubtitle.text = "We sent a code to \(getNumber ?? "") (\(getEmail ?? "")). Please write down."
    }


    // MARK: - CREATE 4 OTP BOXES PROGRAMMATICALLY
    func createOTPBoxes() {

        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(container)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: lblSubtitle.bottomAnchor, constant: 35),
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.heightAnchor.constraint(equalToConstant: 60)
        ])

        var boxes: [UITextField] = []
        let gap: CGFloat = 15

        var previous: UITextField?

        for i in 0..<4 {

            let tf = UITextField()
            tf.translatesAutoresizingMaskIntoConstraints = false
            tf.tag = i
            tf.delegate = self
            tf.keyboardType = .numberPad
            tf.textAlignment = .center
            tf.textColor = .white
            tf.font = .boldSystemFont(ofSize: 24)

            tf.layer.cornerRadius = 12
            tf.layer.borderWidth = 2
            tf.layer.borderColor = UIColor.white.cgColor
            tf.backgroundColor = .clear

            container.addSubview(tf)
            otpFields.append(tf)

            NSLayoutConstraint.activate([
                tf.widthAnchor.constraint(equalToConstant: 60),
                tf.heightAnchor.constraint(equalToConstant: 60),
                tf.topAnchor.constraint(equalTo: container.topAnchor)
            ])

            if let prev = previous {
                tf.leadingAnchor.constraint(equalTo: prev.trailingAnchor, constant: gap).isActive = true
            } else {
                tf.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
            }

            previous = tf

            if i == 3 {
                container.trailingAnchor.constraint(equalTo: tf.trailingAnchor).isActive = true
            }
        }

        otpFields.first?.becomeFirstResponder()
    }

    // MARK: - OTP TYPING HANDLER
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        // Typing
        if string.count == 1 {
            textField.text = string

            if textField.tag < 3 {
                otpFields[textField.tag + 1].becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
                let otp = otpFields.map { $0.text ?? "" }.joined()
                checkMyOtpIs(strMyOtpIsHere: otp)
            }

            return false
        }

        // Backspace
        if string.count == 0 {
            textField.text = ""
            if textField.tag > 0 {
                otpFields[textField.tag - 1].becomeFirstResponder()
            }
            return false
        }

        return true
    }

    // MARK: - RESEND
    @IBAction func resendTapped(_ sender: Any) {
        generateOTP()
    }

    func generateOTP() {
        guard let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] else { return }
        let userId = String(person["userId"] as! Int)

        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")

        let params: Parameters = [
            "action": "generateotp",
            "userId": userId
        ]

        Alamofire.request(BASE_URL_SWIIPE, method: .post, parameters: params).responseJSON { resp in

            ERProgressHud.sharedInstance.hide()

            if let json = resp.value as? [String:Any] {
                if json["status"] as? String == "success" {
                    CRNotifications.showNotification(type: CRNotifications.success, title: "Message!", message: json["msg"] as! String, dismissDelay: 1.5, completion: {})
                } else {
                    CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message: json["msg"] as! String, dismissDelay: 1.5, completion: {})
                }
            }
        }
    }

    // MARK: - VERIFY OTP
    func checkMyOtpIs(strMyOtpIsHere: String) {

        guard let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] else { return }
        let userId = String(person["userId"] as! Int)

        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")

        let params: Parameters = [
            "action": "verifyotp",
            "userId": userId,
            "OTP": strMyOtpIsHere
        ]

        Alamofire.request(BASE_URL_SWIIPE, method: .post, parameters: params).responseJSON { resp in

            ERProgressHud.sharedInstance.hide()

            if let json = resp.value as? [String:Any] {

                if json["status"] as? String == "success" {

                    CRNotifications.showNotification(type: CRNotifications.success, title: "Success", message: json["msg"] as! String, dismissDelay: 1.5, completion: {})

                    let defaults = UserDefaults.standard
                    let loginType = defaults.string(forKey: "KeyLoginPersonal")

                    if loginType == "loginViaPersonal" {
                        self.view.window?.rootViewController?.dismiss(animated: true)
                    } else {
                        let nextVC = UIStoryboard(name: "Main", bundle: .main)
                            .instantiateViewController(withIdentifier: "FinalRegistraitonId")
                        self.present(nextVC, animated: true)
                    }

                } else {
                    CRNotifications.showNotification(type: CRNotifications.error, title: "Error", message: json["msg"] as! String, dismissDelay: 1.5, completion: {})
                }
            }
        }
    }
}

