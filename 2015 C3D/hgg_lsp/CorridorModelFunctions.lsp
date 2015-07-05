(defun C:CORRIDORMODELFUNCTIONS nil
	(cor_func "Add Edit Delete")
	(cor_func_shortcuts "A E D")
	(setq ans (getkword "\nEnter an option [[A]dd/[[E]dit/[D]elete] <Add>: "))
	(if (or (ans == "Add") (ans == "A"))
	)
)