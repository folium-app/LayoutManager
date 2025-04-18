// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import UIKit

@MainActor
public struct LayoutManager {
    public static let shared = LayoutManager()
    
    public var intermediate: UICollectionViewCompositionalLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 20
        
        return .init(sectionProvider: { sectionIndex, layoutEnvironment in
            enum `Type` : Int { case header, play, cheats, coreVersion, kernelMemoryMode, new3DSKernelMemoryMode, publisher, regions, saveStates, delete }
            guard let sectionType = Type(rawValue: sectionIndex) else { return nil }
            
            if [.header, .play, .delete].contains(sectionType) {
                let item: NSCollectionLayoutItem = .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300)))
                
                let group: NSCollectionLayoutGroup = .horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300)), subitem: item, count: 1)
                group.interItemSpacing = .fixed(10)
                
                let section: NSCollectionLayoutSection = .init(group: group)
                section.interGroupSpacing = 10
                if sectionType == .delete {
                    section.contentInsets = .init(top: 20, leading: 0, bottom: 0, trailing: 0)
                }
                
                return section
            } else {
                let item: NSCollectionLayoutItem = .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)))
                
                let group: NSCollectionLayoutGroup = .vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)), subitem: item, count: 1)
                group.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
                group.interItemSpacing = .fixed(10)
                
                let header: NSCollectionLayoutBoundarySupplementaryItem = .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44)),
                                                                                elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                header.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
                
                let footer: NSCollectionLayoutBoundarySupplementaryItem = .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44)),
                                                                                elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
                footer.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
                
                let section: NSCollectionLayoutSection = .init(group: group)
                section.boundarySupplementaryItems = [header, footer]
                section.contentInsets = .init(top: 0, leading: 0, bottom: [.cheats, .saveStates].contains(sectionType) ? 8 : 0, trailing: 0)
                section.interGroupSpacing = 20
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                return section
            }
        }, configuration: configuration)
    }
    
    public var library: UICollectionViewCompositionalLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 20
        
        return .init(sectionProvider: { sectionIndex, layoutEnvironment in
            switch UIDevice.current.userInterfaceIdiom {
            case .pad: iPadLibrary(layoutEnvironment)
            case .phone: iPhoneLibrary(layoutEnvironment)
            default:
                nil
            }
        }, configuration: configuration)
    }
    
    private func iPadLibrary(_ layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        let itemCount: Int = layoutEnvironment.container.effectiveContentSize.width < UIScreen.main.bounds.height ? 5 : 6
        
        let item: NSCollectionLayoutItem = .init(layoutSize: .init(widthDimension: .fractionalWidth(1 / .init(itemCount)), heightDimension: .estimated(300)))
        
        let group: NSCollectionLayoutGroup = .horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300)), subitem: item, count: itemCount)
        group.interItemSpacing = .fixed(10)
        
        let header: NSCollectionLayoutBoundarySupplementaryItem = .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44)),
                                                                        elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let section: NSCollectionLayoutSection = .init(group: group)
        section.boundarySupplementaryItems = [header]
        section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        section.interGroupSpacing = 10
        
        return section
    }
    
    private func iPhoneLibrary(_ layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        let itemCount: Int = layoutEnvironment.container.effectiveContentSize.width < UIScreen.main.bounds.height ? 2 : 4
        
        let item: NSCollectionLayoutItem = .init(layoutSize: .init(widthDimension: .fractionalWidth(1 / .init(itemCount)), heightDimension: .estimated(300)))
        
        let group: NSCollectionLayoutGroup = .horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300)), subitem: item, count: itemCount)
        group.interItemSpacing = .fixed(10)
        
        let header: NSCollectionLayoutBoundarySupplementaryItem = .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44)),
                                                                        elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let section: NSCollectionLayoutSection = .init(group: group)
        section.boundarySupplementaryItems = [header]
        section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        section.interGroupSpacing = 10
        
        return section
    }
}
