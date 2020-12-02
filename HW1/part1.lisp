

;; flattener is main function
;; 

(defun flattener () 
	(if (probe-file "nested_list.txt")
		(with-open-file (str_read "nested_list.txt" :direction :input)
			(with-open-file (str_write "flatenned_list.txt" :direction :output :if-exists :supersede) 
				(format str_write "~A" (read-file str_read))
				'done
			)		
		)
		"nested_list.txt file is not exist"
	)
		
)

;; read-file function reads inside of file by recursion method
;;

(defun read-file (str) 
	(setf value_read (read str nil 'eof))
	(if (eql value_read 'eof)
		nil
		(if (listp value_read) 
			(append (read-nestedlist value_read) (read-file str))
			(cons value_read (read-file str) )
		)
	)

	
)

;;	read-nestedlist reads nested list and append original list by recursion method
;;

(defun read-nestedlist (lst)
	
	(if (zerop (length lst))
		nil
		(if (listp (first lst))
			(append (read-nestedlist (first lst)) (read-nestedlist (setf lst (cdr lst))))
			(append (list (first lst)) (read-nestedlist (setf lst (cdr lst))))
		)
	)
	
)


(flattener)

