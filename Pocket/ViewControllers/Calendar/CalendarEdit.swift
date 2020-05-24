import UIKit



class CalendarEdit: UIViewController  {
    
    var calendarTVCell : CalendarTVCell?

    
    var safeHeight = CGFloat(0)
    
    override func viewDidLoad() {
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = UIColor.systemGray6
        
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        
        setupLabels()
    }
    
    func setupLabels() {
        
        // This needs to be made into a scroll picker
        let categoryLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height*0.2))
        categoryLabel.text = calendarTVCell?.expenseCategory
        categoryLabel.textColor = UIColor.label
        self.view.addSubview(categoryLabel)
        
        
        let categoryDescription = UITextField(frame: CGRect(x: 0, y: categoryLabel.frame.maxY, width: self.view.frame.width, height: self.view.frame.height*0.2))
        
        
        
        
        let notesLabel = UILabel(frame: CGRect(x: 0, y: categoryLabel.frame.maxY, width: self.view.frame.width, height: self.view.frame.height*0.5))
        notesLabel.text = "The Project Gutenberg eBook, The Importance of Being Earnest, by Oscar Wilde   This eBook is for the use of anyone anywhere at no cost and with almost no restrictions whatsoever.  You may copy it, give it away or re-use it under the terms of the Project Gutenberg License included with this eBook or online at www.gutenberg.org      Title: The Importance of Being Earnest        A Trivial Comedy for Serious People   Author: Oscar Wilde    Release Date: August 29, 2006  [eBook #844]  Language: English  Character set encoding: ISO-646-US (US-ASCII)   ***START OF THE PROJECT GUTENBERG EBOOK THE IMPORTANCE OF BEING EARNEST***       Transcribed from the 1915 Methuen & Co. Ltd. edition by David Price, email"
//        notesLabel.text = calendarTVCell?.expenseNotes.text
        notesLabel.textColor = UIColor.label
        
//        self.view.addSubview(notesLabel)
        
    }
    
}
