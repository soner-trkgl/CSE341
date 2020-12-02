;;collatz-finder main method
;;
(defun collatz-finder ()

	(if (probe-file "integer_inputs.txt")
		(progn 
			(with-open-file (str_read "integer_inputs.txt" :direction :input)
				(setf lst (list-reader str_read))
			)
			(if (zerop (length lst))
				"there is no number in integer_inputs.txt file"
				(with-open-file (str_write "collatz_outputs.txt" :direction :output :if-exists :supersede)
					(let ((temp1 0) (temp2 0)) 
						(if (< 5 (length lst) ) 
							(setf temp1 5)
							(setf temp1 (length lst))
						)
						(setf temp2(+ (random temp1 ) 1))
						(do  ((i 0 (+ i 1))) 
							((> i  temp2) )
							(setf temp1 (random (length lst)))
							(format str_write (concatenate 'string (write-to-string (nth temp1 lst)) ": " (collatz-maker (nth temp1 lst)) "~%") )
							(setf lst (remove (nth temp1 lst) lst))
						)	
					)
				)
			)
		)
		"integer_inputs.txt file is not exist"
	)
)

;;list-reader read file for given stream by recursion method
;;
(defun list-reader (str)
	(let ((temp 0)) 
		(if (eql (setf temp (read str nil 'eof)) 'eof)
			nil
			(if (numberp temp)
				(cons temp (list-reader str))
				"there is non-number stuff in integer_inputs.txt file"
			)
		)
	)
)


;;collatz-maker find collatz sequence for giving number via recursion method
;;
(defun collatz-maker (num)
	(if (= num 1)
		""
		(if (evenp num)
			(concatenate 'string (write-to-string (/ num 2)) " "(collatz-maker (/ num 2)) )
			(concatenate 'string (write-to-string (+ (* num 3) 1)) " " (collatz-maker (+ (* num 3) 1)) )
		)
	)

)


(collatz-finder)