//
//  ViewController.swift
//  calcApp
//
//  Created by 松浦 雅人 on 2017/01/07.
//  Copyright © 2017年 松浦 雅人. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tv_history: UITableView!
    @IBOutlet weak var label_disp: UILabel!

    @IBOutlet weak var btn_sub: UIButton!
    @IBOutlet weak var btn_add: UIButton!
    @IBOutlet weak var btn_div: UIButton!
    @IBOutlet weak var btn_times: UIButton!
    @IBOutlet weak var btn_clear: UIButton!
    @IBOutlet weak var btn_ac: UIButton!
    @IBOutlet weak var btn_9: UIButton!
    @IBOutlet weak var btn_8: UIButton!
    @IBOutlet weak var btn_7: UIButton!
    
    @IBOutlet weak var btn_6: UIButton!
    @IBOutlet weak var btn_5: UIButton!
    @IBOutlet weak var btn_4: UIButton!
    
    @IBOutlet weak var btn_3: UIButton!
    @IBOutlet weak var btn_2: UIButton!
    @IBOutlet weak var btn_1: UIButton!
    
    @IBOutlet weak var btn_0: UIButton!
    @IBOutlet weak var btn_dot: UIButton!
    @IBOutlet weak var btn_eq: UIButton!
    
    @IBOutlet weak var btn_clip: UIButton!
    @IBOutlet weak var btn_histDel: UIButton!
    
    @IBOutlet weak var layout_btn1: UIStackView!
    @IBOutlet weak var layout_btn2: UIStackView!
    @IBOutlet weak var layout_btn3: UIStackView!
    @IBOutlet weak var layout_btn4: UIStackView!
    @IBOutlet weak var layout_label: UIStackView!
    @IBOutlet weak var layout_upperMenu: UIStackView!
    
    
    private var temp:String = ""
    var dispStr:String = ""
    var equation:String = ""
    
    var btnArray:[UIButton] = [UIButton]()
    var btnArray2:[UIButton] = [UIButton]()
    
    var numArray:[String] = [String]()
    var opeArray:[String] = [String]()
    
    var historyArray:[HistoryData] = [HistoryData]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //履歴テーブルビュー関連
        self.tv_history.delegate = self
        self.tv_history.dataSource = self
        tv_history.setContentOffset(
            CGPoint(x:0, y:tv_history.contentSize.height - tv_history.frame.size.height),
            animated: false);
        tv_history.separatorColor = UIColor.clear
        
        //ボタンの調整
        setButton()
        //レイアウトの調整
        setLayout()
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //数字ボタン押下時
    internal func tappedNumKey(sender: UIButton){
        switch sender.tag {
        case 0:
            //0キー
            if(temp.isEmpty){
                
            }else{
                temp += "0"
                dispStr += "0"
                label_disp.text = dispStr
            }
        case 1...9:
            //1~9キー
            temp += String("\(sender.tag)")
            dispStr += String("\(sender.tag)")
            label_disp.text = dispStr
            
        case 10:
            //ドットキー
            if(temp.isEmpty){
                
            }else{
                temp += "."
                dispStr += "."
                label_disp.text = dispStr
            }
        default:

            break
        }
    
    }
    
    //演算子系ボタン押下時
    internal func tappedOperator(sender: UIButton){
        
        if(temp.isEmpty && numArray.count==0){
            return
        }
        
        switch sender.tag {
            case 100:
                //バックスペースキー
                if(temp.isEmpty){
                    dispStr.remove(at: dispStr.index(dispStr.endIndex, offsetBy: -1))
                    opeArray.remove(at: opeArray.count-1)
                    temp = numArray[numArray.count-1]
                    numArray.remove(at: numArray.count-1)
                }else{
                    dispStr.remove(at: dispStr.index(dispStr.endIndex, offsetBy: -1))
                    temp.remove(at: temp.index(temp.endIndex, offsetBy: -1))
                }
                
                if(temp.isEmpty && numArray.count==0){
                    label_disp.text = "0"
                }else{
                   label_disp.text = dispStr
                }
            
            case 101:
                //＋キー
                if(temp.isEmpty){
                    dispStr.remove(at: dispStr.index(dispStr.endIndex, offsetBy: -1))
                }else{
                    numArray.append(temp)
                    opeArray.append("+")
                }
                    dispStr += "+"
                    label_disp.text = dispStr
                    temp = ""
            
            case 102:
                //ーキー
                if(temp.isEmpty){
                    dispStr.remove(at: dispStr.index(dispStr.endIndex, offsetBy: -1))
                }else{
                    numArray.append(temp)
                    opeArray.append("-")
                }
                    dispStr += "-"
                    label_disp.text = dispStr
                
                    temp = ""
                
            case 103:
                //×キー
                if(temp.isEmpty){
                    dispStr.remove(at: dispStr.index(dispStr.endIndex, offsetBy: -1))
                }else{
                    numArray.append(temp)
                    opeArray.append("*")
                }
                    dispStr += "×"
                    label_disp.text = dispStr
                    temp = ""

            case 104:
                //÷キー
                if(temp.isEmpty){
                    dispStr.remove(at: dispStr.index(dispStr.endIndex, offsetBy: -1))
                }else{
                    numArray.append(temp)
                    opeArray.append("/")
                }
                    dispStr += "÷"
                    label_disp.text = dispStr
                    temp = ""
            case 105:
                //AC(全削除)キー
                dispStr = ""
                temp = ""
                label_disp.text = "0"
                numArray.removeAll()
                opeArray.removeAll()
            
            default:
                break
        }
        
    }
    
    //イコールボタン押下時
    internal func tappedEqualKey(sender: UIButton){
        
        if(!temp.isEmpty && numArray.count>0){
            numArray.append(temp)
            var equation:String = String("\(atof(numArray[0]))")
            for i in 0..<opeArray.count {
                equation += (opeArray[i] + String("\(atof(numArray[i+1]))"))
            }
            
            let expression = NSExpression(format: equation)
            let result = expression.expressionValue(with: nil, context: nil) as? NSNumber
            
            let histData:HistoryData = HistoryData(dispStr:dispStr, numArray:numArray, opeArray: opeArray)
            historyArray.append(histData)
            tv_history.reloadData()
            tv_history.setContentOffset(
                CGPoint(x:0, y:tv_history.contentSize.height - tv_history.frame.size.height),
                animated: false);
            
            dispStr = String("\(result!)")
            label_disp.text = dispStr
            
            temp = String("\(result!)")
            
            numArray.removeAll()
            opeArray.removeAll()
        }
    }
    
    //上部メニューボタン押下時
    internal func tappedUpperMenu(sender: UIButton){
        
        switch sender.tag {
        case 200:
            //履歴削除ボタン
            historyArray.removeAll()
            tv_history.reloadData()
            
        case 201:
            //クリップボードにコピーボタン
            //コピー処理
            let board = UIPasteboard.general
            board.setValue(dispStr, forPasteboardType: "public.text")
            
            //アラート表示
            let alert: UIAlertController = UIAlertController(title: "コピー", message: "クリップボードにコピーしました", preferredStyle:  UIAlertControllerStyle.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                print("OK")
            })
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        default:
            break
            
        }
        
    }
    
    
    
    //-----------------------
    // TableView for History
    //-----------------------
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // セクションの行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyArray.count
    }
    
    //セルのセット
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell {
        
        let cell: HistoryCell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        cell.setCell(history: historyArray[indexPath.row], index:indexPath.row)
        
        return cell
    }
    
    //リスト選択イベント
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let selectData:HistoryData = historyArray[indexPath.row]
        
        //履歴読み込み
        dispStr = selectData.getDispStr()
        label_disp.text = dispStr
        numArray = selectData.getNumArray()
        temp = numArray[numArray.count-1]
        opeArray = selectData.getOpeArray()
        
        //選択以降の履歴削除
        var max = historyArray.count
        for _ in indexPath.row ..< max {
            historyArray.remove(at: indexPath.row)
            max = historyArray.count
        }
        tv_history.reloadData()
        tv_history.setContentOffset(
            CGPoint(x:0, y:tv_history.contentSize.height - tv_history.frame.size.height),
            animated: true);
        
    }

    
    
    //-----------------
    // Setting Context
    //-----------------
    
    //ボタン配置
    internal func setButton() {
        //数値ボタン+イコール
        btn_1.tag=1
        btnArray.append(btn_1)
        btn_2.tag=2
        btnArray.append(btn_2)
        btn_3.tag=3
        btnArray.append(btn_3)
        btn_4.tag=4
        btnArray.append(btn_4)
        btn_5.tag=5
        btnArray.append(btn_5)
        btn_6.tag=6
        btnArray.append(btn_6)
        btn_7.tag=7
        btnArray.append(btn_7)
        btn_8.tag=8
        btnArray.append(btn_8)
        btn_9.tag=9
        btnArray.append(btn_9)
        btn_0.tag=0
        btnArray.append(btn_0)
        btn_dot.tag=10
        btnArray.append(btn_dot)
        
        btn_eq.tag=999
        btn_eq.addTarget(self, action: #selector(self.tappedEqualKey), for: .touchUpInside)
        btnArray.append(btn_eq)
        
        for i in 0..<btnArray.count-1 {
            btnArray[i].addTarget(self, action: #selector(self.tappedNumKey), for: .touchUpInside)
            btnArray[i].showsTouchWhenHighlighted = true
        }
        
        //オペレーターボタン
        btn_ac.tag=105
        btnArray2.append(btn_ac)
        btn_clear.tag=100
        btnArray2.append(btn_clear)
        btn_div.tag=104
        btnArray2.append(btn_div)
        btn_times.tag=103
        btnArray2.append(btn_times)
        btn_sub.tag=102
        btnArray2.append(btn_sub)
        btn_add.tag=101
        btnArray2.append(btn_add)
        
        
        for i in 0..<btnArray2.count {
            btnArray2[i].addTarget(self, action: #selector(self.tappedOperator), for: .touchUpInside)
            btnArray2[i].showsTouchWhenHighlighted = true
        }
        
        //上部メニューボタン
        btn_histDel.tag = 200
        btn_histDel.addTarget(self, action: #selector(self.tappedUpperMenu(sender:)), for: .touchUpInside)
        btn_clip.tag = 201
        btn_clip.addTarget(self, action: #selector(self.tappedUpperMenu(sender:)), for: .touchUpInside)
    }
    
    
    
    //レイアウトの詳細設定
    internal func setLayout(){
        
        //------------------
        // レイアウトパラメータ
        //------------------
        //左の数字キーの高さ
        let leftBtnHeight:Int = Int(DeviceSize.screenHeight()/7)-5
        //左の数字キーの幅
        let leftBtnWidth:Int = Int(DeviceSize.screenWidth()/4)-5
        //左の数字キーの縦マージン
        let marginTop_leftBtn:Int = 5
        
        //演算ボタンの高さ(AC以外)
        let rightBtnHeight:Int = Int(DeviceSize.screenHeight()/10)-5
        //演算ボタンの高さ(ACのみ)
        let rightBtnHeight_ac:Int = Int(DeviceSize.screenHeight()/15)
        //演算ボタンの縦マージン
        let marginTop_rightBtn:Int = 5
        
        //上部メニューの高さ
        let upperMenuHeight:Int = Int(DeviceSize.screenHeight()/18)
        //履歴テーブルビューの高さ
        let historyViewHeight:Int = Int(DeviceSize.screenHeight()/5)
        //計算結果ビューの高さ
        let labelViewHeight:Int = Int(DeviceSize.screenHeight()/8)
        
        
        
        //縦レイアウト制御
        var h_tmp:Int = 0
        layout_upperMenu.translatesAutoresizingMaskIntoConstraints = true
        layout_upperMenu.frame = CGRect(x:0, y:Int(DeviceSize.statusBarHeight()), width:DeviceSize.screenWidth(), height:upperMenuHeight);
        h_tmp = Int(DeviceSize.statusBarHeight()) + upperMenuHeight
        
        tv_history.translatesAutoresizingMaskIntoConstraints = true
        tv_history.frame = CGRect(x:0, y:h_tmp, width:DeviceSize.screenWidth(), height:historyViewHeight);
        h_tmp += historyViewHeight
        
        layout_label.translatesAutoresizingMaskIntoConstraints = true
        layout_label.backgroundColor = UIColor.black
        layout_label.frame = CGRect(x:0, y:h_tmp, width:DeviceSize.screenWidth(), height:labelViewHeight);
        h_tmp += labelViewHeight + 10
        
        
        layout_btn4.translatesAutoresizingMaskIntoConstraints = true
        layout_btn4.frame = CGRect(x:0, y:h_tmp, width:DeviceSize.screenWidth(), height:leftBtnHeight);
        h_tmp += leftBtnHeight + marginTop_leftBtn
        
        layout_btn3.translatesAutoresizingMaskIntoConstraints = true
        layout_btn3.frame = CGRect(x:0, y:h_tmp, width:DeviceSize.screenWidth(), height:leftBtnHeight);
        h_tmp += leftBtnHeight + marginTop_leftBtn
        
        layout_btn2.translatesAutoresizingMaskIntoConstraints = true
        layout_btn2.frame = CGRect(x:0, y:h_tmp, width:DeviceSize.screenWidth(), height:leftBtnHeight);
        h_tmp += leftBtnHeight + marginTop_leftBtn
        
        layout_btn1.translatesAutoresizingMaskIntoConstraints = true
        layout_btn1.frame = CGRect(x:0, y:h_tmp, width:DeviceSize.screenWidth(), height:leftBtnHeight);
        
        //数字ボタンレイアウト制御
        var v_tmp:Int = 5
        for i in 0..<btnArray.count {
            let btn:UIButton = btnArray[i]
            btn.translatesAutoresizingMaskIntoConstraints = true
            btn.frame = CGRect(x:v_tmp, y:Int(btn.frame.minY), width:leftBtnWidth, height:Int(layout_btn1.frame.size.height))
            
            if((i+1)%3==0){
                v_tmp = 5
            }else{
                v_tmp += (Int(DeviceSize.screenWidth())/4)
            }
        }
        
        //オペランドボタンレイアウト制御
        var v_ope:Int = 0
        var h_ope:Int = 0
        
        v_ope += (Int(DeviceSize.screenWidth())/4)*3 + 5
        h_ope = Int(layout_btn4.frame.minY)
        
        for i in 0..<btnArray2.count {
            let btn_ope:UIButton = btnArray2[i]
            btn_ope.translatesAutoresizingMaskIntoConstraints = true
            if(i==0){
                btn_ope.frame = CGRect(x:v_ope, y:h_ope, width:Int(DeviceSize.screenWidth()/4)-5, height:rightBtnHeight_ac)
                h_ope += rightBtnHeight_ac + marginTop_rightBtn
            }else{
                btn_ope.frame = CGRect(x:v_ope, y:h_ope, width:Int(DeviceSize.screenWidth()/4)-5, height:rightBtnHeight)
                h_ope += rightBtnHeight + marginTop_rightBtn
            }
        }
        
        
        //計算結果ビューのパディング
        label_disp.translatesAutoresizingMaskIntoConstraints = true
        label_disp.frame = CGRect(x:5, y:0, width:Int(DeviceSize.screenWidth())-10, height:Int(layout_label.frame.size.height))
        
    }

}

