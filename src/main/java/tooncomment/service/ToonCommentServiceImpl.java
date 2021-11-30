package tooncomment.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Service;

import tooncomment.bean.ToonCommentDTO;
import tooncomment.dao.ToonCommentDAO;

@Service
public class ToonCommentServiceImpl implements ToonCommentService {
	@Autowired
	private ToonCommentDAO toonCommentDAO;
	
	@Override
	public void toonCommentWrite(ToonCommentDTO toonCommentDTO) {
		toonCommentDAO.toonCommentWrite(toonCommentDTO);
		
	}

}