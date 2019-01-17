import UIKit
import AVKit
import AVFoundation

class movieViewController: UIViewController {
    @IBOutlet weak var movie_Label1: UILabel!
    @IBOutlet weak var movie_Label2: UILabel!
    @IBOutlet weak var movie_Lavel3: UILabel!
    @IBOutlet weak var movie_Label4: UILabel!
    
    @IBOutlet weak var Image1: UIImageView!
    @IBOutlet weak var Image2: UIImageView!
    @IBOutlet weak var Image3: UIImageView!
    @IBOutlet weak var Image4: UIImageView!
    var imageView:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button_layout()
        Image1.image = UIImage(named:"udetate_man")
    }
    
    func button_layout(){
        movie_Label1.text = "腕立て"
        movie_Label1.font = movie_Label1.font.withSize(20)
        movie_Label1.textAlignment = NSTextAlignment.center
        
        movie_Label2.text = "腹筋"
        movie_Label2.font = movie_Label1.font.withSize(20)
        movie_Label2.textAlignment = NSTextAlignment.center
        
        movie_Lavel3.text = "スクワット"
        movie_Lavel3.font = movie_Label1.font.withSize(20)
        movie_Lavel3.textAlignment = NSTextAlignment.center
        
        movie_Label4.text = "ダンベル上げ"
        movie_Label4.font = movie_Label1.font.withSize(20)
        movie_Label4.textAlignment = NSTextAlignment.center
    }
    
    //動画再生
    func moviePlay(movieURL: String){
        guard let url = URL(string: movieURL) else {
            return
        }
        let player = AVPlayer(url: url)
        let controller = AVPlayerViewController()
        controller.player = player
        // 動画再生
        present(controller, animated: true) {
            player.play()
        }
    }

    @IBAction func movie_Button1(_ sender: Any) {
        moviePlay(movieURL: "https://s3-ap-northeast-1.amazonaws.com/kintoremovie/udetatenokihonn+.mp4")
    }
    
    @IBAction func movie_Button2(_ sender: Any) {
        moviePlay(movieURL: "https://s3-ap-northeast-1.amazonaws.com/kintoremovie/hukkin.mp4")
    }
    
    @IBAction func movie_Button3(_ sender: Any) {
        moviePlay(movieURL: "https://s3-ap-northeast-1.amazonaws.com/kintoremovie/sukusuku.mp4")
    }
    
    @IBAction func movie_Button4(_ sender: Any) {
        moviePlay(movieURL: "https://s3-ap-northeast-1.amazonaws.com/kintoremovie/danberu.mp4")
    }
    
}
