//
//  ViewController.swift
//  blackjack
//
//  Created by Student on 6/27/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var topView: UIView!
    @IBOutlet var bottomView: UIView!
    
    @IBOutlet var topViewConstraint: NSLayoutConstraint!
    @IBOutlet var bottomViewConstraint: NSLayoutConstraint!
    
    @IBOutlet var dealerView: UIView!
    @IBOutlet var playerView: UIView!
    
    @IBOutlet var playerValueUI: UILabel!
    @IBOutlet var dealerValueUI: UILabel!
    
    @IBOutlet var cashUI: UILabel!
    
    @IBOutlet var backgroundEnd: UIView!
    @IBOutlet var statusEnd: UILabel!
    
    @IBOutlet var backgroundEndHeight: NSLayoutConstraint!
    @IBOutlet var backgroundEndWidth: NSLayoutConstraint!
    
    var cash: Double = 300
    var dealerCards: BlackjackHand = BlackjackHand(cards: [])
    var secondDealerCard: BlackjackCard = BlackjackCard(suit: "", rank: "")
    var playerCards: BlackjackHand = BlackjackHand(cards: [])
    var playing: Bool = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        topViewConstraint.constant = view.frame.width
        bottomViewConstraint.constant = view.frame.width
        
        backgroundEndHeight.constant = view.frame.height
        backgroundEndWidth.constant = view.frame.width
        
        startPlay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updatePlayerValueUI () -> Void {
        if playerCards.value[0] == playerCards.value[1] {
            playerValueUI.text = String(playerCards.value[0])
        } else {
            playerValueUI.text = String(playerCards.value[0]) + "/" + String(playerCards.value[1])
        }
    }
    
    func updateDealerValueUI () -> Void {
        if dealerCards.value[0] == dealerCards.value[1] {
            dealerValueUI.text = String(dealerCards.value[0])
        } else {
            dealerValueUI.text = String(dealerCards.value[0]) + "/" + String(dealerCards.value[1])
        }
    }
    
    func calculateWinner () {
        updatePlayerValueUI()
        dealerCards.cards.append(secondDealerCard)
        dealerCards = BlackjackHand(cards: dealerCards.cards)
        while (dealerCards.value[0] < 17 && dealerCards.value[1] < 17) {
            dealerCards.cards.append(pickCard())
            dealerCards = BlackjackHand(cards: dealerCards.cards)
        }
        makeView(dealerCards, viewUI: self.dealerView)
        updateDealerValueUI()
        
        let tcash = cash
        if playerCards.bust[0] && dealerCards.bust[0] {
            cash += 100
        } else if dealerCards.bust[0] {
            cash += 100*1.5
        } else if dealerCards.value[1] == playerCards.value[1] && !dealerCards.bust[1] {
            cash += 100
        } else if dealerCards.value[0] == playerCards.value[0] && dealerCards.bust[1] && !dealerCards.bust[0] && playerCards.bust[1] {
            cash += 100
        } else if dealerCards.value[1] > playerCards.value[1] && !dealerCards.bust[1] {
        
        } else if dealerCards.value[1] > playerCards.value[0] && !dealerCards.bust[1] {
            
        } else if dealerCards.value[0] > playerCards.value[1] && !dealerCards.bust[0] && !playerCards.bust[1] {
            
        } else if dealerCards.value[0] > playerCards.value[0] && !dealerCards.bust[0] {
            
        } else if playerCards.value[1] > dealerCards.value[1] && !playerCards.bust[1] && !dealerCards.bust[1] {
            cash += 100*1.5
        } else if playerCards.value[1] > dealerCards.value[0] && !playerCards.bust[1] && !dealerCards.bust[0] {
            cash += 100*1.5
        } else if playerCards.value[0] > dealerCards.value[1] && !playerCards.bust[0] && !dealerCards.bust[1] {
            cash += 100*1.5
        } else if playerCards.value[0] > dealerCards.value[0] && !playerCards.bust[0] && !dealerCards.bust[0] {
            cash += 100*1.5
        } else if playerCards.blackjack && dealerCards.blackjack {
            cash += 100
        } else if playerCards.blackjack && !dealerCards.blackjack {
            cash += 100*1.5
        } else if playerCards.t21 && dealerCards.t21 && !dealerCards.blackjack {
            cash += 100
        } else if playerCards.t21 && !dealerCards.t21 && !dealerCards.blackjack {
            cash += 100*1.5
        } else if playerCards.value[0] == dealerCards.value[0] && !dealerCards.blackjack {
            cash += 100
        } else if playerCards.value[1] == dealerCards.value[1] && !playerCards.bust[1] && !dealerCards.bust[1] && !dealerCards.blackjack {
            cash += 100
        }
        
        if (cash-tcash) == 100 {
            statusEnd.text = "You tied!"
        } else if (cash-tcash) > 100 {
            statusEnd.text = "You won!"
        } else {
            statusEnd.text = "You lost!"
        }
        cashUI.text = "Cash: " + String(Int(cash))
        
        backgroundEnd.hidden = false
    }
    
    func updatePlaying () -> Void {
        if playerCards.bust[0] || playerCards.blackjack || playerCards.t21 {
            playing = false
            calculateWinner()
        } else {
            playerCards.cards.append(pickCard())
            playerCards = BlackjackHand(cards: playerCards.cards)
            makeView(playerCards, viewUI: self.playerView)
            if playerCards.bust[0] || playerCards.blackjack || playerCards.t21 {
                playing = false
                calculateWinner()
            }
        }
        updatePlayerValueUI()
    }
    
    func startPlay () -> Void {
        backgroundEnd.hidden = true
        makeDeck()
        
        var tempCardsDealer: [BlackjackCard] = []
        tempCardsDealer.append(pickCard())
        dealerCards = BlackjackHand(cards: tempCardsDealer)
        makeView(dealerCards, viewUI: self.dealerView)
        
        secondDealerCard = pickCard()
        let secondDealerCardUI = UIImageView()
        secondDealerCardUI.image = UIImage(named: "back")
        secondDealerCardUI.frame = CGRectMake(100, 0, 75, 125)
        self.dealerView.addSubview(secondDealerCardUI)
        self.dealerView.bringSubviewToFront(secondDealerCardUI)
        
        var tempCardsPlayer: [BlackjackCard] = []
        for _ in 1...2 {
            tempCardsPlayer.append(pickCard())
        }
        playerCards = BlackjackHand(cards: tempCardsPlayer)
        makeView(playerCards, viewUI: self.playerView)
        
        if playerCards.bust[0] || playerCards.blackjack || playerCards.t21 {
            playing = false
            calculateWinner()
        }
        
        updatePlayerValueUI()
        updateDealerValueUI()
        cash -= 100
        cashUI.text = "Cash: " + String(Int(cash))
        playing = true
    }
    
    @IBAction func standButton(sender: UIButton) {
        if playing {
            playing = false
            
            calculateWinner()
        }
    }
    @IBAction func hitButton(sender: UIButton) {
        if playing {
            updatePlaying()
        }
    }
    
    @IBAction func endStart(sender: AnyObject) {
        startPlay()
    }
    
    
    
    
    func randomInRange(lo: Int, hi : Int) -> Int {
        return lo + Int(arc4random_uniform(UInt32(hi - lo + 1)))
    }
    
    func makeView(hand: BlackjackHand, viewUI: UIView) {
        viewUI.subviews.forEach({ $0.removeFromSuperview() })
        for i in (0...(hand.cards.count-1)).reverse() {
            let card = UIImageView()
            card.image = UIImage(named: hand.cards[i].rank + "_of_" + hand.cards[i].suit)
            if i == (hand.cards.count-1) {
                card.frame = CGRectMake(500, 0, 75, 125)
                UIView.animateWithDuration(0.5, delay: 0, options: [.CurveEaseOut], animations: {
                    card.frame = CGRectMake(((CGFloat(hand.cards.count-1-i))*37), 0, 75, 125)
                }, completion: nil)
            } else {
                card.frame = CGRectMake(((CGFloat(hand.cards.count-1-i))*37), 0, 75, 125)
            }
            viewUI.addSubview(card)
            viewUI.bringSubviewToFront(card)
            
        }
    }
    
    var cards: [BlackjackCard] = []
    var suits: [String] = ["hearts","diamonds","spades","clubs",]
    func makeDeck () -> Void {
        for i in 0...(suits.count-1) {
            for j in 2 ... 10 {
                cards.append(BlackjackCard(suit: suits[i], rank: String(j)))
            }
            cards.append(BlackjackCard(suit: suits[i], rank: "ace"))
            cards.append(BlackjackCard(suit: suits[i], rank: "king"))
            cards.append(BlackjackCard(suit: suits[i], rank: "queen"))
            cards.append(BlackjackCard(suit: suits[i], rank: "jack"))
        }
    }
    func pickCard () -> BlackjackCard {
        let random = randomInRange(0, hi: (cards.count-1))
        let card = cards[random]
        cards.removeAtIndex(random)
        
        return card
    }
    
}

class BlackjackCard {
    var suit: String
    var rank: String
    var value: [Int] = []
    
    init(suit: String, rank: String) {
        self.suit = suit
        self.rank = rank
        
        let temp = Int(rank)
        self.value = [10,10]
        if temp != nil {
            self.value = [temp! as Int,temp! as Int]
        } else if rank == "ace" {
            self.value = [1,11]
        }
    }
}

class BlackjackHand {
    var value: [Int] = [0,0]
    var cards: [BlackjackCard] = []
    
    var bust: [Bool] = [false,false]
    var blackjack: Bool = false
    var t21: Bool = false
    
    init(cards: [BlackjackCard]) {
        self.cards = cards
        if cards.count > 0 {
            for i in 0...(cards.count-1) {
                self.value[0] += cards[i].value[0]
                self.value[1] += cards[i].value[1]
            }
            if self.value[0] > 21 {
                self.bust[0] = true
                self.bust[1] = true
            } else if self.value[0] == 21 {
                if cards.count == 2 {
                    blackjack = true
                } else {
                    t21 = true
                }
            }
            if self.value[1] > 21 {
                self.bust[1] = true
            } else if self.value[1] == 21 {
                if cards.count == 2 {
                    blackjack = true
                } else {
                    t21 = true
                }
            }
        }
    }
}