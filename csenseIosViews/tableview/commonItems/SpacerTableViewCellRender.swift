//
// Created by Kasper T on 24/11/2017.
// Copyright (c) 2017 commonsense. All rights reserved.
//

import Foundation

public class SpacerTableViewCell: UITableViewCell {
}

public class SpacerTableViewCellRender: BaseTableViewItemRender<SpacerTableViewCell> {

    private let height: CGFloat

    init(height: CGFloat) {
        self.height = height
        super.init(reuseIdentifier: "SpacerTableViewCell", nibName: "SpacerTableViewCell", bundle: nil)
    }

    public override func onRowHeight() -> CGFloat? {
        return height
    }

    public override func onEstimateRowHeight() -> CGFloat? {
        return height
    }
}
