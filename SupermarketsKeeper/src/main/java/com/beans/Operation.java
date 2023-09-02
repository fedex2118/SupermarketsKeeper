package com.beans;

public class Operation {
	private int id;
	private String query;
	
	private String description = "PlaceholderText";
	
	public Operation(int id, String query) {
		this.id = id;
		this.query = query;
	}
	
	public int getId() {
		return id;
	}
	
	public String getQuery() {
		return query;
	}
	
	public void setDescription(String description) {
		this.description = description;
	}
	
	public String getDescription() {
		return description;
	}
}
