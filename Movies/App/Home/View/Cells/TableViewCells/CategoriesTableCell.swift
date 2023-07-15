import UIKit

struct Category{
    let text: String
    var isSelected: Bool = false
}

class CategoriesTableCell: UITableViewCell {
    var selectedCategoryIndex: Int = 0
    var categoryDidSelect: ((Int) -> ())?
    
    private var categories = [
        Category(text: "Now Playing", isSelected: true),
        Category(text: "Upcoming"),
        Category(text: "Top Rated"),
        Category(text: "Popular")
    ]
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cView.delegate = self
        cView.backgroundColor = .clear
        cView.dataSource = self
        cView.showsHorizontalScrollIndicator = false
        cView.register(CategoriesCollectionCell.self, forCellWithReuseIdentifier: "CategoriesCollectionCell")
        return cView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(40)
        }
    }
}

extension CategoriesTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let font = UIFont.systemFont(ofSize: 16, weight: .bold)
        let text = categories[indexPath.row].text
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let textWidth = (text as NSString).size(withAttributes: attributes).width
        let cellWidth = textWidth + 10
        return CGSize(width: cellWidth, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let indexes = [IndexPath(row: selectedCategoryIndex, section: 0), IndexPath(row: indexPath.row, section: 0)]
        categories[selectedCategoryIndex].isSelected = false
        categories[indexPath.row].isSelected = true
        selectedCategoryIndex = indexPath.row
        collectionView.reloadItems(at: indexes)
        collectionView.scrollToItem(at: indexes[1], at: .centeredHorizontally, animated: true)
        categoryDidSelect?(selectedCategoryIndex)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionCell", for: indexPath) as! CategoriesCollectionCell
        cell.configure(category: categories[indexPath.row])
        return cell
    }
}
