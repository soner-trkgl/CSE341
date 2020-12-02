;; primecrawler main function
;;
(defun primecrawler()
	(if (probe-file "boundries.txt")
		(with-open-file (str_read "boundries.txt" :direction :input)
			(if (eql (setf num1 (read str_read nil 'eof)) 'eof)
				"two numbers are required in boundries.txt"
				(if (numberp num1) 
					(if (eql (setf num2 (read str_read nil 'eof)) 'eof)
						"two numbers are required in boundries.txt"
						(if (numberp num2)
							(with-open-file (str_write "primedistrubition.txt" :direction :output :if-exists :supersede)
								(let ((temp 0))
									(if (> num1 num2) 
										(progn 
											(setf temp num2)
											(setf num2 num1)
											(setf num1 temp)
										)
										
									)
								)
								(do ((j num1 (+ j 1)))
									((> j num2 ) 'done)
									(if (primep j)
										(format str_write "~D is Prime~%" j )
										(if (semi-primep j)
											(format str_write "~D is Semi-prime~%" j )
										)
									)
								)
								
							)
							"there is no number in boundries.txt"
						)
					)
					"there is no number in boundries.txt"
				)
			)
		)
		"boundries.txt file is not exist"
	)
)

;; primep function find given number whether prime or not
;;

(defun primep(num)
	(let ((temp 0))
		(if (< num 2)
			nil
			(do ((i 2 (+ i 1)))
				((> i (- num 1)) (if (zerop temp) (not nil) nil ))
				(if (zerop (mod num i))
					(setf temp (+ temp 1))
					(setf temp temp)
				)
			)
		)
		
	)
		
		
)

;; semi-primep find given number whether semi-prime or not
;;

(defun semi-primep (num)
	(let ((temp 1) )
		(if (< num 4)
			nil
			(do ((i 2 (+ i 1))) 
				((> i (/ num temp)) nil)
				(if (primep i)
					(if (zerop (mod num i))
						(if (primep (/ num i))
							(return (not nil))
							(setf temp i)
						)
						(setf temp i)
					)
					(setf temp i)
				)
			)
		)
			
	)
)


(primecrawler)





