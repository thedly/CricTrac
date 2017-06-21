//
//  AddMatchIntroScreens.swift
//  CricTrac
//
//  Created by AIPL on 20/06/17.
//  Copyright © 2017 CricTrac. All rights reserved.
//

import UIKit

class AddMatchIntroScreens: UIPageViewController,UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    
    //lazy var vcArray:[]
    lazy var vcArray:[UIViewController] = {
        return [self.VCInstance("FirstScreenIntroVC"),
                self.VCInstance("SecScreenIntroVC"),
                self.VCInstance("ThirdScreenIntroVC")
                ]
    }()
    
    private func VCInstance(name:String) -> UIViewController {
    
    return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(name)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        if let firstVC = vcArray.first {
            setViewControllers([firstVC], direction:.Forward, animated: true, completion: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in self.view.subviews {
            if view is UIScrollView {
                view.frame = UIScreen.mainScreen().bounds
            }
            else if view is UIPageControl {
                view.backgroundColor = UIColor.clearColor()
            }
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = vcArray.indexOf(viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        guard vcArray.count >= previousIndex else {
            return nil
        }
        return vcArray[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = vcArray.indexOf(viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < vcArray.count else {
            return nil
        }
        guard vcArray.count > nextIndex else {
            return nil
        }
        
        return vcArray[nextIndex]
    }
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int{
        // The number of items reflected in the page indicator.
        return vcArray.count
    }
    
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        // The selected item reflected in the page indicator.
        guard let firstViewController = viewControllers?.first , let firstViewControllerIndex = vcArray.indexOf(firstViewController) else {
            return 0
        }
        return firstViewControllerIndex
        
    }
    


    
}
