open Graph

type fc = {
	flow : int ; 
	capacity : int } 

type path = (id*id) list

type queue = (id*id*bool) list


(************************************)
(* ----------- INITIALIZE --------- *)
(************************************)

(* Construct a flow graph from a given capacity graph *)
let init_graph gr = Graph.map gr (fun capacity -> {flow = 0; capacity})

(************************************)
(* ------------- TOUR ------------- *)
(************************************)

(* Return the same graph but without arcs *)
let graph_without_arcs gr = 
	let result = empty_graph in
	let f acu id out_arcs = add_node acu id in
	v_fold gr f result

(* ----- QUEUE ----- *)

(* Add an element to the queue *)
let q_add q e = e::q

(* Return the id of the first element not marked in the queue *)
let rec q_first_not_marked q = match q with
	|[] -> None
	|(id, _,false)::tl -> Some id
	|hd::tl -> q_first_not_marked tl

(* Check if the given node already exists in the queue *)
let q_exists q id = List.exists (fun (x, _, _) -> x = id) q 

(* Mark the element with the given id *)
let q_mark_element q id = 
	let rec loop q id acu = match q with
		|[] -> acu 
		|(id, father, false)::tl -> List.append (List.append acu (id, father, true)) tl
		|(id, _, true)::tl -> failwith "element already marked"
		|hd::tl -> loop tl id (List.append acu [hd])
	in loop q id []

(* Build a path from a queue *)
let q_build_path q = 
	let q_id_first ((id, _, _)::tl) = id in
	let rec loop q id path = match q with
		|[] -> path
		|(id, father, _)::tl -> loop tl father (id, father)::path
		|(_, _, _)::tl -> loop tl id path
	in loop q (q_id_first q) []

(* Construct a residual graph from a capacity graph *)
let residual_graph gr = 
	let result = graph_without_arcs gr in
	let rec f acu id out_arcs = match out_arcs with
		| [] -> acu
		| (idD,{flow = 0; capacity})::tail -> f (add_arc acu id idD capacity) id tail
		| (idD,{flow = flot; capacity = capa})::tail -> 
			if flot == capa 
			then f (add_arc acu idD id flot) id tail 
			else f (add_arc (add_arc acu idD id flot) id idD (capa-flot)) id tail  	
	in
	v_fold gr f result

(* Find the minimal cost of a path *)
let find_min_from_path gr path = 
	let path_label_first ((id1,id2)::tail) = find_arc gr id1 id2 in 
	let rec loop remaining_path min = match remaining_path with
		| [] -> min
		| (idS, idD)::tl -> 
			if (find_arc gr idS idD) < min 
			then loop tl (find_arc gr idS idD) 
			else loop tl min
	in loop tail path_label_first
	
(* Tour a residual graph to find a path from source to sink, and its minimal cost *)
let tour_residual_graph gr source sink = 
	let rec loop gr current_node q =  
		ajouter tous les fils de current_node à la file 
			si l'un des fils est le puits, on arrête la fct après l'avoir ajouté
			si ils ne sont pas déjà dedans
		marquer current_node

	in loop gr source []
	extraire le path associé à la file finale
	extraire le min du path
	
	renvoyer (path, min)
	
	

(************************************)
(* ------------ UPDATE ------------ *)
(************************************)

(* Update a flow graph according to an incrementation path and its minimal cost *)
let update_graph gr path cost = assert false

(************************************)
(* -------- FORD-FULKERSON -------- *)
(************************************)

