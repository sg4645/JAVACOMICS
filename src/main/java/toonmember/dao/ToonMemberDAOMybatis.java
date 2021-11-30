package toonmember.dao;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import toonmember.bean.ToonMemberDTO;

@Repository
@Transactional
public class ToonMemberDAOMybatis implements ToonMemberDAO {
	@Autowired
	private SqlSession sqlSession;
	
	@Override
	public void toonMemberWrite(ToonMemberDTO toonMemberDTO) {
		sqlSession.insert("toonmemberSQL.toonMemberWrite",toonMemberDTO);
		
	}

	@Override
	public ToonMemberDTO checkId(String id) {
		return sqlSession.selectOne("toonmemberSQL.checkId",id);
	}

}