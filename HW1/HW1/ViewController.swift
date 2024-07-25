//
//  ViewController.swift
//  HW1
//
//  Created by CDMStudent on 4/15/24.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        Initial_data() // Here we are initializing random data
        update_a()
        update_b()
    }
    
    var data_a: [Int] = [] // This array is for holding view a data
    var data_b: [Int] = [] // This array is for holding view b data
    var Bars_count: Int = 16 // This will set the initial bar count
    let Bar_gap: CGFloat = 1 // This will set the gaps between the bars
    var Step_count: Int = 0 // This is set and count the sorting steps
    
    // Below is the button to sort array
    @IBAction func Sort_btn(_ sender: Any) {
        Step_count = 0
        Sort()
    }
    
    // Below is the label outlet for label N =
    @IBOutlet weak var label_n: UILabel!
    
    // Below is the outlet for array length segmented control
    @IBOutlet weak var array_length: UISegmentedControl!
    
    @IBAction func array_length(_ sender: UISegmentedControl) {
        
        // This will show the bar count according to the case selected
        switch sender.selectedSegmentIndex {
            
        case 0:
            Bars_count = 16
        case 1:
            Bars_count = 32
        case 2:
            Bars_count = 48
        case 3:
            Bars_count = 64
        default:
            break
            
        }
        Initial_data()
        update_a()
        update_b()
    }
    
    @IBOutlet weak var algo_a: UISegmentedControl! // This is the segmented control for view a
    
    @IBOutlet weak var View_a: UIView! // This is view a
    
    @IBOutlet weak var algo_b: UISegmentedControl! // This is the segmented control for view a
    
    @IBOutlet weak var View_b: UIView! // This is view b
    
    // Here this function will create line bars
    func Bar_lines(in view: UIView, with color: UIColor, data: [Int]) {
        view.subviews.forEach { $0.removeFromSuperview() }
        
        let Total_count = CGFloat(data.count)
        let Width = (view.frame.width - (Total_count - 1) * Bar_gap) / Total_count
        let Max = CGFloat(data.max() ?? 1)
        
        // This will set the dimentions, color and position for all the elements in array into both views
        for (index, value) in data.enumerated() {
            let Height = view.frame.height * CGFloat(value) / Max
            let X_position = (Width + Bar_gap) * CGFloat(index)
            let Dimention = CGRect(x: X_position, y: view.frame.height - Height, width: Width, height: Height)
            let Bar_view = UIView(frame: Dimention)
            Bar_view.backgroundColor = color
            view.addSubview(Bar_view)
        }
    }
    
    // This function will sort the numbers after sort button is clicked
    func Sort() {
        
        var Data_index_a: [Int] = []
        
        var Data_index_b: [Int] = []
        
        guard Step_count < Bars_count else {
            return
        }
        
        switch algo_a.selectedSegmentIndex {  // This switch performs based on selected sorting algorithm for view a
            
        case 0:
            Data_index_a = InsertionSort_algo(&data_a, view: "A")
        case 1:
            Data_index_a = SelectionSort_algo(&data_a, view: "A")
        case 2:
            Data_index_a = QuickSort_algo(&data_a, low: 0, high: data_a.count - 1, view: "A")
        case 3:
            Data_index_a = MergeSort_algo(&data_a, view: "A")
        default:
            break
        }
        
        switch algo_b.selectedSegmentIndex { // This switch performs based on selected sorting algorithm for view b
            
        case 0:
            Data_index_b = InsertionSort_algo(&data_b, view: "B")
        case 1:
            Data_index_b = SelectionSort_algo(&data_b, view: "B")
        case 2:
            Data_index_b = QuickSort_algo(&data_b, low: 0, high: data_b.count - 1, view: "B")
        case 3:
            Data_index_b = MergeSort_algo(&data_b, view: "B")
        default:
            break
        }
        // This dispatch queue will add 0.25 delay in the sorting animation and update the views step by step
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            
            self.Step_count += 1
            self.update_a()
            self.update_b()
            self.Sort()
            // Here we call the animation function to update views
            self.Swap_animation(in: self.View_a, from: self.data_a, Data_index: Data_index_a, with: .systemTeal)
            self.Swap_animation(in: self.View_b, from: self.data_b, Data_index: Data_index_b, with: .systemTeal)
        }
    }
    
    // This function is for insertion sort algo
    func InsertionSort_algo(_ array: inout [Int], view: String) -> [Int] {
        guard array.count > 1 else { return [] }
        
        var Data_index: [Int] = []
        var j = Step_count
        
        if Step_count >= array.count {
            return Data_index
        }
                
        while j > 0 && array[j] < array[j - 1] {
            
            array.swapAt(j, j - 1)
            
            Data_index.append(j)
            Data_index.append(j - 1)
            
            j -= 1
        }
        
        return Data_index
    }
    
    // This function is for selection sort algo
    func SelectionSort_algo(_ array: inout [Int], view: String) -> [Int] {
        guard array.count > 1 else { return [] }
        
        var Data_index: [Int] = []
        var Min_index = Step_count
        
        if Step_count >= array.count - 1 {
            return Data_index
        }
            
        for j in Step_count + 1..<array.count {
            
            if array[j] < array[Min_index] {
                Min_index = j
            }
        }
        if Min_index != Step_count {
            
            array.swapAt(Step_count, Min_index)
            
            Data_index.append(Step_count)
            Data_index.append(Min_index)
        }
        
        return Data_index
    }
    
    // This function is for quick sort algo
    func QuickSort_algo(_ array: inout [Int], low: Int, high: Int, view: String) -> [Int] {
        guard low < high else {
            return []
        }
        
        var Data_index: [Int] = []
        
        let pivot = Partition_method(&array, low: low, high: high, Data_index: &Data_index)
        
        if Step_count < pivot {
            Data_index += QuickSort_algo(&array, low: low, high: pivot - 1, view: view)
        } else if Step_count > pivot {
            Data_index += QuickSort_algo(&array, low: pivot + 1, high: high, view: view)
        }
        
        return Data_index
    }

    // This function is for partition method to be used in quick sort
    func Partition_method(_ array: inout [Int], low: Int, high: Int, Data_index: inout [Int]) -> Int {
        
        var i = low

        let pivot = array[high]
        
        for j in low..<high {
            
            if array[j] <= pivot {
                
                array.swapAt(i, j)
                
                Data_index.append(i)
                Data_index.append(j)
                
                i += 1
            }
        }
        
        array.swapAt(i, high)
        
        Data_index.append(i)
        Data_index.append(high)
        
        return i
    }

    // This function is for merge sort algo
    func MergeSort_algo(_ array: inout [Int], view: String) -> [Int] {
        guard array.count > 1 else { return [] }
        
        var Data_index: [Int] = []
        
        let mid = array.count / 2
        var Left_Array = Array(array[0..<mid])
        var Right_Array = Array(array[mid..<array.count])
                
        Data_index += MergeSort_algo(&Left_Array, view: view)
        Data_index += MergeSort_algo(&Right_Array, view: view)
        
        var L_Index = 0
        var R_Index = 0
        var A_Index = 0
        
        while L_Index < Left_Array.count && R_Index < Right_Array.count {
            
            if Left_Array[L_Index] < Right_Array[R_Index] {
                array[A_Index] = Left_Array[L_Index]
                L_Index += 1
            } else {
                array[A_Index] = Right_Array[R_Index]
                R_Index += 1
            }
            A_Index += 1
        }
        
        while L_Index < Left_Array.count {
            array[A_Index] = Left_Array[L_Index]
            L_Index += 1
            A_Index += 1
        }
        
        while R_Index < Right_Array.count {
            array[A_Index] = Right_Array[R_Index]
            R_Index += 1
            A_Index += 1
        }
        
        return Data_index
    }

    // This will update the bars in view a
    func update_a() {
        Bar_lines(in: View_a, with: .systemTeal, data: data_a)
    }
    
    // This will update the bars in view b
    func update_b() {
        Bar_lines(in: View_b, with: .systemTeal, data: data_b)
    }
    
    // This will generate random array data for both views
    func Initial_data() {
        data_a = (0..<Bars_count).map { _ in Int.random(in: 1...100) }
        data_b = data_a
    }
    
    // This function animates the bar swapping
    func Swap_animation(in view: UIView, from data: [Int], Data_index: [Int], with color: UIColor) {
        
        for i in stride(from: 0, to: Data_index.count, by: 2) {
            
            let First_Index = Data_index[i]
            let Second_Index = Data_index[i + 1]
            
            guard First_Index < data.count && Second_Index < data.count else {
                continue
            }
            
            let First_Bar = view.subviews[First_Index]
            let Second_Bar = view.subviews[Second_Index]
            
            let Set_View_a = First_Bar.frame
            let Set_View_b = Second_Bar.frame
            
            UIView.animate(withDuration: 0.25) {  // This is the swap operation
                
                First_Bar.frame = Set_View_b
                Second_Bar.frame = Set_View_a
            }
        }
    }
}

