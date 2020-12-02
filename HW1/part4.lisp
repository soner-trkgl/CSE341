(defun main()
	(if (probe-file "paragraph.txt")
		(progn
			(with-open-file (str "paragraph.txt" :direction :input :EXTERNAL-FORMAT CHARSET:utf-8)
				(setf total-phrase (read-file str))
				
			)

			(setf compressed-list nil)
			(do ((i 0 ))
				((zerop (length total-phrase)) )
				(cons (list (char-occurence (aref total-phrase i) total-phrase) (aref total-phrase i)) compressed-list)
				(setf total-phrase (remove (aref total-phrase i) total-phrase ))
			)
			

		)
		"paragraph.txt is not exist"
	)
)


( defun read-file (str)
	(let ((get-str "")) 
		(if (eql 'eof (setf get-str (read-line str nil 'eof) ))
			""
			(concatenate 'string get-str (read-file str))
		)
	)
)

(defun char-occurence (ch phrase)
	(let ((temp 0))
		(do ((i 0 (+ i 1)))
			((> i (- (length phrase) 1)) temp)
			(if (eql ch (aref phrase i))
				(setf temp (+ temp 1))
			)
		)
	)
)

(main)
