//
//  ViewController.swift
//  Suji tore  Muscle_training
//
//  Created by mac on 2018/11/22.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var kinniku: UIImageView!
    @IBOutlet weak var i_train: UIImageView!
    @IBOutlet weak var i_info: UIImageView!
    @IBOutlet weak var i_muscle: UIImageView!
    @IBOutlet weak var i_num: UIImageView!
    @IBOutlet weak var quotation_human: UIImageView!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UILabel!
    @IBOutlet weak var label8: UILabel!
    @IBOutlet weak var condition: UILabel!
    @IBOutlet weak var ResetButton: UIButton!
    @IBOutlet weak var ReloadButto: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var textField: UITextField!
    
    
    //画像についての変数
    var image1: UIImage!
    var image2: UIImage!
    var imageView:UIImageView!
    
    //加速度センサについての変数
    let motionManager = CMMotionManager()
    
    var acceleX: Double = 0
    var acceleY: Double = 0
    var acceleZ: Double = 0
    let Alpha = 0.5
    var flg: Bool = false
    
    var count = 0
    var start = 0
    var before: Double = 0
    var result: Double = 0
    
    //路線に関する変数
    var pickerView: UIPickerView = UIPickerView()
    let list = ["", "ＪＲ福塩線", "ＪＲ山手線", "ＪＲ総武本線", "東京メトロ日比谷線", "ＪＲ常磐線", "東京メトロ千代田線", "小田急小田原線", "ＪＲ東北本線(黒磯－福島)", "ＪＲ総武本線", "ＪＲ成田線(千葉－銚子)", "京王新線", "ＪＲ播但線", "東武伊勢崎線", "京王相模原線", "ＪＲ羽越本線(新発田－酒田)", "ＪＲ只見線", "ＪＲ奈良線", "都営大江戸線"]
    var stationName = ""
    var status = ""
    var mustCount = 0
    
    //音楽に関する変数
    var audioPlayer1:AVAudioPlayer!
    var audioPlayer2:AVAudioPlayer!
    
    //viewDidLoad()の処理
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        
        //加速度についての処理
        if motionManager.isAccelerometerAvailable {
            // intervalの設定 [sec]
            motionManager.accelerometerUpdateInterval = 0.2
            
            // センサー値の取得開始
            motionManager.startAccelerometerUpdates(
                to: OperationQueue.current!,
                withHandler: {(accelData: CMAccelerometerData?, errorOC: Error?) in
                    self.lowpassFilter(acceleration: accelData!.acceleration)
            })
        }
        
        //路線のボタンに関する処理
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, 0, 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ViewController.done))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(ViewController.cancel))
        toolbar.setItems([cancelItem, doneItem], animated: true)
        
        self.textField.inputView = pickerView
        self.textField.inputAccessoryView = toolbar
        
        //Audioに関する処理
        AudioPlay1()
        AudioPlay2()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //レイアウト
    func layout(){
        image.image = UIImage(named:"logo_x")
        
        let random = String(arc4random_uniform(5))
        kinniku.image = UIImage(named:"quotation\(random)")
        
        
        i_train.image = UIImage(named:"i_train")
        i_info.image = UIImage(named:"i_info")
        i_muscle.image = UIImage(named:"i_muscle")
        i_num.image = UIImage(named:"i_count")
        
        label1.text = "路線名"
        label1.textAlignment = NSTextAlignment.center
        label2.text = "筋トレメニュー"
        label2.textAlignment = NSTextAlignment.center
        label3.text = "現在の回数"
        label3.textAlignment = NSTextAlignment.center
        label4.text = "運行情報"
        label4.textAlignment = NSTextAlignment.center
        
        label5.textAlignment = NSTextAlignment.center
        label6.textAlignment = NSTextAlignment.center
        label8.textAlignment = NSTextAlignment.center
        textField.textAlignment = NSTextAlignment.center
        startButton.setTitle("筋トレSTART！", for: .normal)
        startButton.titleLabel!.font = UIFont(name: "Helvetica-Bold",size: CGFloat(30))
    }
    
    //動画画面から戻る処理
    @IBAction func goHome(segue: UIStoryboardSegue){
    
    }
    
    //運行情報についての処理
    private func getOperationInformation(station : String){
        if(station==""){
            status = "路線を選択してください"
        }else{
            var text = "http://hack1.dstn.club/dataspider/trigger/status?route=\(station)"
            text = text.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            let url3 = URL(string: text)
            let request3 = URLRequest(url: url3!)
            let session3 = URLSession.shared
            session3.dataTask(with: request3) { (data, response, error) in
                if error == nil, let data = data, let response = response as? HTTPURLResponse {
                    // HTTPヘッダの取得
                    print("Content-Type: \(response.allHeaderFields["Content-Type"] ?? "")")
                    // HTTPステータスコード
                    print("statusCode: \(response.statusCode)")
                    if (String(data: data, encoding: String.Encoding.utf8) ?? "" == ""){
                        self.status = "なし"
                        
                    }else{
                        self.status = (String(data: data, encoding: String.Encoding.utf8) ?? "")
                        print(String(data: data, encoding: String.Encoding.utf8) ?? "")
                    }
                }
            }.resume()
        }
    }
    
    //ここから加速度センサについての処理
    func lowpassFilter(acceleration: CMAcceleration){
        before = acceleY
        if(before < 0){
            before = before * (-1.0)
        }
        
        acceleY = Alpha * acceleration.y + acceleY * (1.0 - Alpha);
        result = floor(acceleY * acceleY) - floor(before)
        if(result == 1.0 && start == 1){
            count = count + 1
            label8.text = String("\(count) 回 / \(mustCount) 回")
            if(count == mustCount){
                start = 2
            }
        }else if(start == 2){
            if ( audioPlayer1.isPlaying ){
                audioPlayer1.stop()
            }
            audioPlayer2.play()
            label8.text = String("\(mustCount) 回 / \(mustCount) 回")
            label8.textColor = UIColor.red
        }
    }
    
    func stopAccelerometer(){
        if (motionManager.isAccelerometerActive) {
            motionManager.stopAccelerometerUpdates()
        }
    }
    
    @IBAction func startButton(_ sender: Any) {
        start = 1
        count = 0
        label8.text = String("\(count) 回 / \(mustCount) 回")
        condition.text = "YES 筋トレ"
        condition.textColor = UIColor.blue
        
        audioPlayer1.play()
    }
    
    @IBAction func movieButton(_ sender: Any) {
        count = 0
        start = 0
        condition.text = "NOT 筋トレ"
        condition.textColor = UIColor.red
        
        label8.text = String("\(mustCount) 回 / \(mustCount) 回")
        label8.textColor = UIColor.black
        
        let random = String(arc4random_uniform(5))
        kinniku.image = UIImage(named:"quotation\(random)")
        
        if ( audioPlayer1.isPlaying ){
            audioPlayer1.stop()
        }
        
        if ( audioPlayer2.isPlaying ){
            audioPlayer2.stop()
        }
    }
    
    
    //ここからプルダウンメニューについて
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.textField.text = list[row]
        
        stationName = list[row]
        getOperationInformation(station: stationName)
    }
    
    @objc func cancel() {
        self.textField.text = ""
        self.textField.endEditing(true)
        label6.text = "路線を選択してください"
    }
    
    @objc func done() {
        self.textField.endEditing(true)
        label6.text = status
        menu_label(status: status)
        print("現在のstatus3\(status)")
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    //筋トレメニューに関する処理
    func menu_label(status: String){
        if(status == "平常運転"){
            label5.text = "腕上げ"
            mustCount = 10
            label8.text = String("\(count) 回 / \(mustCount) 回")
        }else if(status == "運転再開"){
            label5.text = "背筋"
            mustCount = 20
            label8.text = String("\(count) 回 / \(mustCount) 回")
        }else if(status == "列車遅延"){
            label5.text = "腕立て"
            mustCount = 30
            label8.text = String("\(count) 回 / \(mustCount) 回")
        }else if(status == "運転状況"){
            label5.text = "腕立て"
            mustCount = 15
            label8.text = String("\(count) 回 / \(mustCount) 回")
        }else if(status == "区間平常運転"){
            label5.text = "うさぎ跳び"
            mustCount = 5
            label8.text = String("\(count) 回 / \(mustCount) 回")
        }else if(status == "その他"){
            label5.text = "腹筋"
            mustCount = 25
            label8.text = String("\(count) 回 / \(mustCount) 回")
        }else if(status == "なし"){
            label5.text = "スクワット"
            mustCount = 3
            label8.text = String("\(count) 回 / \(mustCount) 回")
        }else if(status == "運転見合わせ"){
            label5.text = "体幹トレーニング"
            mustCount = 3
            label8.text = String("\(count) 回 / \(mustCount) 回")
        }else{
            label5.text = "路線を選択してください"
        }
    }
    
    func AudioPlay1(){
        // 再生する audio ファイルのパスを取得
        let audioPath = Bundle.main.path(forResource: "muscleRoad", ofType:"mp3")!
        let audioUrl = URL(fileURLWithPath: audioPath)
        
        
        // auido を再生するプレイヤーを作成する
        var audioError:NSError?
        do {
            audioPlayer1 = try AVAudioPlayer(contentsOf: audioUrl)
        } catch let error as NSError {
            audioError = error
            audioPlayer1 = nil
        }
        
        // エラーが起きたとき
        if let error = audioError {
            print("Error \(error.localizedDescription)")
        }
        
        audioPlayer1.delegate = self as? AVAudioPlayerDelegate
        audioPlayer1.prepareToPlay()
    }
    
    func AudioPlay2(){
        // 再生する audio ファイルのパスを取得
        let audioPath = Bundle.main.path(forResource: "UNICORN_win", ofType:"mp3")!
        let audioUrl = URL(fileURLWithPath: audioPath)
        
        
        // auido を再生するプレイヤーを作成する
        var audioError:NSError?
        do {
            audioPlayer2 = try AVAudioPlayer(contentsOf: audioUrl)
        } catch let error as NSError {
            audioError = error
            audioPlayer2 = nil
        }
        
        // エラーが起きたとき
        if let error = audioError {
            print("Error \(error.localizedDescription)")
        }
        
        audioPlayer2.delegate = self as? AVAudioPlayerDelegate
        audioPlayer2.prepareToPlay()
    }

}

