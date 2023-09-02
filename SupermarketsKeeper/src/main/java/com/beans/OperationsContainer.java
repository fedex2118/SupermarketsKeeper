package com.beans;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Vector;
import java.util.stream.Collectors;

public class OperationsContainer {
	private Vector<Operation> operationsArray = new Vector<>();
	
	public Operation getOperation(int id) {
		return operationsArray.get(id - 1);
	}
	
	public Vector<Operation> getOperations() {
		return operationsArray;
	}
	
	public void initializeContainer(String path) throws IOException {
		InputStream resource = OperationsContainer.class.getResourceAsStream(path);
		
		List<String> righe = new BufferedReader(new InputStreamReader(resource,
				StandardCharsets.UTF_8)).lines().collect(Collectors.toList());
		
		StringBuffer sb = null;
		int id = 0;
		boolean saveNextLine = false;
		
        for(String st: righe) {
            if(saveNextLine) {
            	sb.append(st + " "); // save the string of the operation
            	if(st.contains(";")) { // end of query, let's save the operation on the container
            		String query = sb.toString();
            		query = query.trim();
            		query = query.replaceAll("\"", "^");
            		Operation op = new Operation(id, query);
            		operationsArray.add(op);
            		saveNextLine = false;
            	}
            }
            
            if(st.startsWith("--")) {
            	if(st.contains("VIEW")) // skip operations made with view VIEW
            		continue;
            	String[] stringArray = st.split(" ");
            	id = Integer.parseInt(stringArray[2]); // fetch the id of the operation
            	sb = new StringBuffer();
            	saveNextLine = true;
            }

        }
        
    	addDescrToOperations("/operations/DescrOperazioni.txt");
	}
	
	private void addDescrToOperations(String path) throws IOException {
		InputStream resource = OperationsContainer.class.getResourceAsStream(path);
		
		
		List<String> righe = new BufferedReader(new InputStreamReader(resource,
				StandardCharsets.UTF_8)).lines().collect(Collectors.toList());
		int id = 0;
		
		for(String st: righe) {
			String[] stringArray = st.split("--");
			id = Integer.parseInt(stringArray[0]); // fetch id
			Operation operation = getOperation(id); // get operation by id
			String description = stringArray[1]; // fetch description
			operation.setDescription(description); // set description
		}
	}
}
