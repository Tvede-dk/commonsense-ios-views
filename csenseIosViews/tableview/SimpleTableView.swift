//
//  SimpleTableView.swift
//  csenseIosViews
//
//  Created by Kasper T on 04/11/2017.
//  Copyright © 2017 commonsense. All rights reserved.
//

import Foundation
import csenseSwift
import UIKit

public class SimpleTableView : UITableView {
    
    private let data = TableDataContainer()
    
    private var registredIdentifiers : Set<String> = Set()
    
    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        hookup()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        hookup()
    }
    
    public func addData(item : GenericTableItem, inSection : Int){
        data.addData(item: item, inSection: inSection)
        let nib = item.getNib()
        let reuseId = item.getReuseIdentifier()
        if !containsNibAndReuse(nib: nib, reuseId : reuseId){
            addNibAndReuseId(nib: nib, reuseId : reuseId)
            register(nib, forCellReuseIdentifier: reuseId )
        }
    }
    
    private func containsNibAndReuse(nib : UINib, reuseId : String) -> Bool{
        return registredIdentifiers.contains(reuseId)
    }
    
    func addNibAndReuseId(nib : UINib, reuseId : String){
        registredIdentifiers.update(with: reuseId)
    }
    
    private func hookup(){
        dataSource = data
        delegate = data
    }
    
}
