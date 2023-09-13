//
//  ViewController.swift
//  Hangman
//
//  Created by Ak on 06/06/23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var manFace: UIImageView!
    @IBOutlet var manLeftHand: UIImageView!
    @IBOutlet var manRightHand: UIImageView!
    @IBOutlet var manBody: UIImageView!
    @IBOutlet var manLeftLeg: UIImageView!
    @IBOutlet var manRightLeg: UIImageView!

    @IBOutlet var winsCount: UILabel!
    @IBOutlet var lossesCount: UILabel!

    @IBOutlet var positionFirst: UILabel!
    @IBOutlet var positionSecond: UILabel!
    @IBOutlet var positionThird: UILabel!
    @IBOutlet var positionFourth: UILabel!
    @IBOutlet var positionSixth: UILabel!
    @IBOutlet var positionFifth: UILabel!
    @IBOutlet var positionSeventh: UILabel!

    @IBOutlet var timeCounter: UILabel!

    // count timer varibles
    var totalTime = 60 // in seconds
    var myTimer: Timer?
    var countTimerRunning = false

    // Words
    var animals = ["cheetah", "dolphin", "giraffe", "Penguin"]
    var flowers = ["Jasmine", "fuchsia", "Rosebay", "Spiraea"]
    var sports = ["Bowling", "Cricket", "Netball", "Cycling"]
    var gadgets = ["scanner", "Monitor", "Speaker", "Printer"]

    var word: String = ""

    var wordChars = [Character]()

    // CORRECT CHARS ARRAY
    var correctChars = [String]()

    // INCORRECT CHARS ARRAY
    var incorrectChars = [String]()

    // MAINTAIN A COUNT OF HANGMAN PARTS
    var count = 0

    var wins: Int = 0
    var losses: Int = 0

    // TYPES
    var WIN_TYPE = "WIN"
    var LOST_TYPE = "LOST"
    var MAX_GUESS = 6

    // BUTTIONS with BACKGROUND COLOR SET
    var keysWithBgColor: [UIButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        manFace.isHidden = true
        manLeftHand.isHidden = true
        manRightHand.isHidden = true
        manBody.isHidden = true
        manLeftLeg.isHidden = true
        manRightLeg.isHidden = true

        word = word.uppercased()
        for c in word {
            wordChars.append(c)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.actionCategoriesHandler()
        }
    }

    @IBAction func onKeyboardKeyPress(_ sender: UIButton) {
        print(sender.currentTitle ?? "not sure")
        checkChar(char: sender.currentTitle ?? "", button: sender)
    }

    // FUNCTION CHECKS FOR CHARACTER IS A PART OF WORD
     func checkChar(char: String, button: UIButton) {
        // check if it's a part of word
        // if yes then change the color to green or else red
        print("Character \(char) is pressed! and chars are \(wordChars)")

        if wordChars.contains(char) {

            if let index = wordChars.firstIndex(of: Character(char)) {
                fillTheLine(position: index + 1, value: char)
                button.backgroundColor = UIColor.green
                correctChars.append(char)
                keysWithBgColor.append(button)
                wordChars[index] = "-"
            }

            // check if guess is right
            if correctChars.count == wordChars.count {
                self.checkResult(type: WIN_TYPE)
            }

        } else {
            print("Not part of \(char))")
            incorrectChars.append(char)

            button.backgroundColor = UIColor.red
            keysWithBgColor.append(button)

            // increase count
            count = count + 1

            // add hangman body part
            addBodyPart(count: count)

            if count == MAX_GUESS {
                self.checkResult(type: LOST_TYPE)
            }
        }
    }

     func addBodyPart(count: Int) {
        switch count {
        case 1:
            manFace.isHidden = false
        case 2:
            manBody.isHidden = false
        case 3:
            manLeftHand.isHidden = false
        case 4:
            manRightHand.isHidden = false
        case 5:
            manLeftLeg.isHidden = false
        case 6:
            manRightLeg.isHidden = false
        default:
            print("Nothing to print here just show alert")
        }
    }

     func checkResult(type: String) {
        if type == LOST_TYPE {
            print("Lost the game")

            if let lossesText = lossesCount.text, let lossCount = Int(lossesText) {
                lossesCount.text = String(lossCount + 1)
            }
            self.gameOver(type: LOST_TYPE)
        }
        
        if type == WIN_TYPE {
            if let winsText = winsCount.text, let winCount = Int(winsText) {
                winsCount.text = String(winCount + 1)
            }
            self.gameOver(type: WIN_TYPE)
        }
    }

     func fillTheLine(position: Int, value: String) {
        switch position {
        case 1:
            positionFirst.text = value
        case 2:
            positionSecond.text = value
        case 3:
            positionThird.text = value
        case 4:
            positionFourth.text = value
        case 5:
            positionFifth.text = value
        case 6:
            positionSixth.text = value
        case 7:
            positionSeventh.text = value
        default:
            return print("Something is wrong here!")
        }
    }

     func runCountTimer() {
        if !countTimerRunning {
            myTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.updateCountTimer), userInfo: nil, repeats: true)
            countTimerRunning = true
        }
    }

    @objc  func updateCountTimer() {
        totalTime = totalTime - 1

        if totalTime >= 0 {
            timeCounter.text = String(totalTime)
        } else {
            gameOver(type: LOST_TYPE)
        }
    }

    func stopTimer() {
        myTimer?.invalidate()
        myTimer = nil
        countTimerRunning = false
        totalTime = 60
    }

    func gameOver(type: String) {
        if type == WIN_TYPE {
            self.hangmanExpression(type: WIN_TYPE)
            self.alertHandler(type: WIN_TYPE)
        } else {
            self.hangmanExpression(type: LOST_TYPE)
            self.alertHandler(type: LOST_TYPE)
        }
    }
    
    func hangmanExpression(type: String) {
        let happyImage = UIImage(named: "happy")
        let sadImage = UIImage(named: "sad")
        
        if manFace.isHidden {
            manFace.isHidden = false
        }

        if type == WIN_TYPE && (happyImage != nil) {
            manFace.image = happyImage
        }
        
        if type == LOST_TYPE && (sadImage != nil) {
            manFace.image = sadImage
        }

    }

     func resetValues() {
        let faceImage = UIImage(named: "circle")
        if faceImage != nil {
            manFace.image = faceImage
        }
        
        self.stopTimer()
        count = 0
        word = ""
        timeCounter.text = "0"
        correctChars.removeAll()
        incorrectChars.removeAll()
        manFace.isHidden = true
        manLeftHand.isHidden = true
        manRightHand.isHidden = true
        manBody.isHidden = true
        manLeftLeg.isHidden = true
        manRightLeg.isHidden = true
        positionFirst.text = ""
        positionSecond.text = ""
        positionThird.text = ""
        positionFourth.text = ""
        positionFifth.text = ""
        positionSixth.text = ""
        positionSeventh.text = ""

        self.clearAllKeys()

        self.actionCategoriesHandler()
    }

    func alertHandler(type: String) {

        if type == WIN_TYPE && self.presentedViewController == nil {
            let newAlert = UIAlertController(title: "Woohoo!", message: "I'm safe! Would you like to play again?", preferredStyle: .alert)

            let playAgainAction = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
                self?.resetValues()
            }
            let backToHomeAction = UIAlertAction(title: "No", style: .default) { [weak self] _ in
                self?.quitApp()
            }
            newAlert.addAction(playAgainAction)
            newAlert.addAction(backToHomeAction)
            self.present(newAlert, animated: true, completion: nil)
        }

        if type == LOST_TYPE && self.presentedViewController == nil {
            let newAlert = UIAlertController(title: "Sorry!", message: "The correct word was \(word). Would you like to play again?", preferredStyle: .alert)

            let playAgainAction = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
                self?.resetValues()
            }
            let backToHomeAction = UIAlertAction(title: "No", style: .default) { [weak self] _ in
                self?.quitApp()
            }
            newAlert.addAction(playAgainAction)
            newAlert.addAction(backToHomeAction)
            self.present(newAlert, animated: true, completion: nil)
        }
    }

    func assignWord(randomWord: String) {
        word = randomWord.uppercased()
        wordChars.removeAll()
        for c in word {
            wordChars.append(c)
        }

        runCountTimer()
    }

    func actionCategoriesHandler() {
        let alertActionSheet = UIAlertController(title: "HANGMAN", message: "Choose a category", preferredStyle: .actionSheet)
        let Animal = UIAlertAction(title: "Animal", style: .default, handler: { _ in
            // get any random word from animals array
            // then set to word variable
            if let animal = self.animals.randomElement() {
                print("Animal is \(animal)")
                self.assignWord(randomWord: animal)
            }
        })
        let Flowers = UIAlertAction(title: "Flowers", style: .default, handler: { _ in
            if let flower = self.flowers.randomElement() {
                print("Flower is \(flower)")
                self.assignWord(randomWord: flower)
            }

        })
        let Sports = UIAlertAction(title: "Sports", style: .default, handler: { _ in
            if let sport = self.sports.randomElement() {
                print("Sports is \(sport)")
                self.assignWord(randomWord: sport)
            }

        })
        let Gadgets = UIAlertAction(title: "Gadgets", style: .default, handler: { _ in
            if let gadget = self.gadgets.randomElement() {
                print("gadgets is \(gadget)")
                self.assignWord(randomWord: gadget)
            }

        })

        alertActionSheet.addAction(Gadgets)
        alertActionSheet.addAction(Sports)
        alertActionSheet.addAction(Flowers)
        alertActionSheet.addAction(Animal)

        present(alertActionSheet, animated: true, completion: nil)
    }

    func clearAllKeys() {
        for btn in keysWithBgColor {
            btn.backgroundColor = UIColor.systemGray5
        }
        keysWithBgColor.removeAll()
    }

    func quitApp() {
        self.resetValues()
        exit(0)
    }
}
