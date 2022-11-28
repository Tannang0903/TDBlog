package models.DAO;

import java.util.ArrayList;import org.hibernate.validator.internal.util.logging.formatter.ObjectArrayFormatter;

import core.Mapper.ResultSetMapper.PostResultSetMapper;
import models.Bean.Post;

public class PostDAO extends BaseDAO<Post>{
	public PostDAO() {
		super(new PostResultSetMapper());
	}
	
	public ArrayList<Post> getAllWithPostAndAuthor() {
		String query = """
				SELECT POST.*, USER.NAME AS 'AUTHOR', TAG.NAME AS 'TAG' FROM POST INNER JOIN TAG
				ON POST.TAGID = TAG.ID
				INNER JOIN USER
				ON POST.AUTHORID = USER.ID
		""";
		return this.getRecordArray(query);
	}
	public Post getWithTagAndAuthor(String id) {
		String query = """
				SELECT POST.*, USER.NAME AS 'AUTHOR', TAG.NAME AS 'TAG' FROM POST INNER JOIN TAG
				ON POST.TAGID = TAG.ID
				INNER JOIN USER
				ON POST.AUTHORID = USER.ID 
				WHERE POST.ID = ?
		""";
		return this.getRecordSingle(query, new Object[] {id});
	}
	
	public Post getById(String id) {
		String query = "SELECT * FROM POST WHERE ID = ?";
		return this.getRecordSingle(query, new Object[] {id});
	}
	public boolean updateView(String id, int view) {
		String query = "UPDATE POST SET VIEWCOUNT = ? WHERE ID = ?";
		return this.executeQuery(query, new Object[] {id, view});
	}
	public boolean deletePost(String id) {
		String query = "DELETE FROM POST WHERE ID = ?";
		return this.executeQuery(query, new Object[] {id});
	}
	
}
