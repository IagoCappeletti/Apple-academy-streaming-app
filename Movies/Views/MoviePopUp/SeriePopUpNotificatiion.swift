//
//  SeriePopUpNotificatiion.swift
//  Movies
//
//  Created by ios-noite-6 on 14/07/24.
//

import UIKit

class SeriePopUpNotificatiion: UIView {

    @IBOutlet weak var buttonClose: UIButton!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect){
        super.init(frame: frame)

        setupXib(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height ))
    }
    
    func setupXib(frame: CGRect){
        let view = loadXib()
        view.frame = frame
        addSubview(view)
    }
    
    func loadXib() -> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SeriePopUpNotificationView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return view
    }
    
}
