use supermarkets_keeper;

-- Operazione 1 CONTAINS_DATA
INSERT INTO ProdottoElaborato VALUES("Patatine", "Puff", 1.20, NULL);

-- Operazione 2 CONTAINS_DATA
INSERT INTO Supermercato VALUES(25, "Carrefour", "Via Carlo Santi", 112, 00175, FALSE, FALSE, "Milano", "Italia", "Iveco", 3);

-- Operazione 3 CONTAINS_DATA
INSERT INTO CatenaTrasporto Values("Abe Express", NULL);

use supermarkets_keeper;

-- Operazione 4 CONTAINS_DATA
SELECT NomeProdSuper, Marchio, p1.QuantitàVendute, NomeCatena
FROM ProdottiInSupermercato as p1, Supermercato as s1
WHERE  s1.IdS = p1.IdS AND p1.QuantitàVendute IN (SELECT p2.QuantitàVendute
						     FROM ProdottiInSupermercato as p2, Supermercato as s
						     WHERE NomeCatena = "Conad" AND p2.IdS = s.IdS);

-- Operazione 5
SELECT IdS, NomeCatena, s.NomeCatenaTr
FROM Supermercato as s, CatenaTrasporto as c1
WHERE c1.NomeCatenaTr = s.NomeCatenaTr AND c1.Rating > (SELECT AVG(c2.Rating)
													    FROM CatenaTrasporto as c2);

-- Operazione 5 VIEW
SELECT IdS, NomeCatena, NomeCatenaTr
FROM SupermarketsCatenaTrRating as s
WHERE s.Rating > (SELECT AVG(c.Rating)
				FROM CatenaTrasporto as c);
                  
-- Operazione 6
SELECT NomeProdMag, p1.IdM, c.NomeCittà
FROM ProdottiInMagazzino as p1, Città as c, Magazzino as m
WHERE p1.IdM = m.IdM AND c.NomeCittà = m.NomeCittà
AND p1.Quantità < (SELECT AVG(p2.Quantità)
				FROM ProdottiInMagazzino as p2);

-- Operazione 6 VIEW
SELECT NomeProdMag, p1.IdM, NomeCittà
FROM ProdMagQuantitàIdMCittà as p1
WHERE p1.Quantità < (SELECT AVG(p2.Quantità)
				FROM ProdottiInMagazzino as p2);

-- Operazione 7
SELECT v.Targa, v.Modello, v.Capienza
FROM Veicolo as v, TrasportoMerciAcquistate as t, ProdottiInMagazzino as p1
WHERE v.Targa = t.Targa AND t.NomeProd = p1.NomeProdMag AND t.Marchio = p1.Marchio
AND p1.Quantità = (SELECT MAX(p2.Quantità)
				  FROM ProdottiInMagazzino as p2
                  WHERE p2.IdM = p1.IdM)
                  GROUP BY v.Targa;

-- Operazione 7 VIEW
SELECT t.Targa, t.Modello, t.Capienza
FROM TargaModelloCapNomeProdMarchioQuantitàIdMInMag as t
WHERE t.Quantità = (SELECT MAX(p.Quantità)
				  FROM ProdottiInMagazzino as p
                  WHERE p.IdM = t.IdM)
                  GROUP BY t.Targa;

-- Operazione 8
SELECT p1.Stipendio
FROM Persona as p1
WHERE p1.Stipendio <= (SELECT AVG(p2.Stipendio)
				   FROM Persona as p2, Supermercato as s
                   WHERE GrandeDistribuzione = TRUE AND p2.IdS = s.IdS)
                   GROUP BY p1.Stipendio;

-- Operazione 9 CONTAINS_DATA
SELECT p1.NomeProdMag, p1.Marchio, p1.Quantità, t.QuantitàTrasportata
FROM ProdottiInMagazzino as p1, TrasportoMerciAcquistate as t
WHERE p1.NomeProdMag = t.NomeProd AND p1.Marchio = t.Marchio 
AND DataImmagazzinamento = "2021-06-15" AND p1.IdM = t.IdM
AND QuantitàTrasportata <= ANY (SELECT p2.Quantità
					 FROM ProdottiInMagazzino as p2
                     WHERE p2.NomeProdMag = p1.NomeProdMag AND p2.Marchio = p1.Marchio);
                  


-- Operazione 10
SELECT NomeProdSuper, NomeCatena
FROM ProdottiInSupermercato as ps, Supermercato as s
WHERE ps.IdS = s.IdS AND ps.QuantitàVendute < ALL (SELECT pm1.Quantità
									FROM ProdottiInMagazzino as pm1
									WHERE pm1.Quantità 
                                    < (SELECT AVG(pm2.Quantità)
									   FROM ProdottiInMagazzino as pm2));
                        

-- Operazione 10 VIEW
SELECT NomeProdSuper, NomeCatena
FROM SupNomeCIdSGDistrNomeProdMarchioQuantQuantVRicavoTot as s
WHERE s.QuantitàVendute < ALL (SELECT pm1.Quantità
					FROM ProdottiInMagazzino as pm1
					WHERE pm1.Quantità < (SELECT AVG(pm2.Quantità)
										  FROM ProdottiInMagazzino as pm2));


-- Operazione 11
SELECT NomeCatGrezzi, QuantitàProdotta, f.NomeProdGrezzo, f.Marchio
FROM FornituraProdGrezzo as f, ProdottoGrezzo as p1
WHERE f.NomeProdGrezzo = p1.NomeProdGrezzo AND f.Marchio = p1.Marchio
AND p1.Prezzo < (SELECT MAX(p2.Prezzo)
				FROM ProdottoGrezzo as p2)
                GROUP BY QuantitàProdotta;
                

-- Operazione 12
SELECT NomeCatElaborati, QuantitàProdotta, f.NomeProdElaborato, f.Marchio
FROM FornituraProdElaborato as f, ProdottoElaborato as p1
WHERE f.NomeProdElaborato = p1.NomeProdElaborato AND f.Marchio = p1.Marchio
AND p1.Prezzo > (SELECT AVG(p2.Prezzo)
				FROM ProdottoElaborato as p2);

-- Operazione 13
SELECT p.NomeProdMag, p.Marchio, t.QuantitàTrasportata
FROM ProdottiInMagazzino as p, TrasportoMerciImmagazzinate as t
WHERE p.IdM = t.IdM AND t.QuantitàTrasportata > (SELECT MIN(Capienza)
												 FROM Veicolo as v, CatenaTrasporto as c1
												 WHERE v.NomeCatenaTr = c1.NomeCatenaTr AND c1.Rating = (SELECT MAX(c2.Rating)
																										 FROM CatenaTrasporto as c2));

-- Operazione 14 CONTAINS_DATA
SELECT p1.NomeProdSuper, p1.Marchio
FROM ProdottiInSupermercato as p1, Supermercato as s1
WHERE p1.IdS = s1.IdS AND s1.NomeCatena = "Conad" AND s1.GrandeDistribuzione = TRUE
AND NOT EXISTS(SELECT p2.NomeProdSuper, p2.Marchio
			   FROM ProdottiInSupermercato as p2, Supermercato s2
			   WHERE p2.IdS = s2.IdS AND s2.NomeCatena = "Carrefour"
               AND p1.NomeProdSuper = p2.NomeProdSuper AND p1.Marchio = p2.Marchio);

-- Operazione 14 VIEW
SELECT s1.NomeProdSuper, s1.Marchio
FROM SupermarketsNomeCatenaIdSGDistrNomeProdQuantità as s1
WHERE s1.NomeCatena = "Conad" AND s1.GrandeDistribuzione = TRUE
AND NOT EXISTS(SELECT s2.NomeProdSuper, s2.Marchio
			   FROM SupermarketsNomeCatenaIdSGDistrNomeProdQuantità as s2
			   WHERE s2.NomeCatena = "Carrefour" 
               AND s1.NomeProdSuper = s2.NomeProdSuper AND s1.Marchio = s2.Marchio);


-- Operazione 15
SELECT p1.Nome, p1.CodFisc, p1.Stipendio
FROM Persona as p1, Supermercato as s
WHERE p1.IdS = s.IdS AND p1.Direttore = TRUE AND s.Grossisti = TRUE
AND p1.Stipendio < (SELECT MAX(p2.Stipendio)
				   FROM Persona as p2
                   WHERE p2.Direttore = TRUE);


-- Operazione 16 CONTAINS_DATA
SELECT a1.IdA, QuantitàAcquistata, NomeProdGrezzo, Marchio
FROM Acquisizione as a1, FornituraProdGrezzo as f1
WHERE a1.IdA = f1.IdA AND a1.QuantitàAcquistata IN (SELECT a2.QuantitàAcquistata
												FROM Acquisizione as a2, FornituraProdGrezzo as f2
                                                WHERE a2.IdA = f2.IdA AND f2.NomeProdGrezzo = "Anguria" AND f2.Marchio = "Gavina");

-- Operazione 16 VIEW
SELECT IdA, QuantitàAcquistata, NomeProdGrezzo, Marchio
FROM FornituraGrezziAcquisizione as f1
WHERE f1.QuantitàAcquistata IN (SELECT a2.QuantitàAcquistata
							   FROM Acquisizione as a2, FornituraProdGrezzo as f2
							   WHERE a2.IdA = f2.IdA AND f2.NomeProdGrezzo = "Anguria" AND f2.Marchio = "Gavina");


-- Operazione 17 CONTAINS_DATA
SELECT NomeCatElaborati, p1.NomeProdElaborato
FROM FornituraProdElaborato as f1, ProdottoElaborato as p1
WHERE f1.NomeProdElaborato = p1.NomeProdElaborato AND f1.Marchio = p1.Marchio 
AND f1.QuantitàProdotta > (SELECT MAX(f2.QuantitàProdotta)
						  FROM FornituraProdElaborato as f2, ProdottoElaborato as p2
						  WHERE f2.NomeProdElaborato = p2.NomeProdElaborato AND f2.Marchio = p2.Marchio 
                          AND p2.Prezzo > 5 AND f2.DataProduzione >= "2022-01-01" AND f2.DataProduzione < "2023-01-01")
                          GROUP BY NomeCatElaborati;


-- Operazione 18
SELECT f1.NomeProdGrezzo, f1.Marchio, f1.IdFG, f1.NomeCatGrezzi, a1.DataAcquisto
FROM FornituraProdGrezzo as f1, Acquisizione as a1
WHERE f1.IdA = a1.IdA AND a1.DataAcquisto = (SELECT MAX(a2.DataAcquisto)
                                          FROM FornituraProdGrezzo as f2, Acquisizione as a2
										  WHERE f2.IdA = a2.IdA);

-- Operazione 18 VIEW
SELECT f1.NomeProdGrezzo, f1.Marchio, f1.IdFG, f1.NomeCatGrezzi
FROM FornituraGrezziAcquisizione as f1
WHERE f1.DataAcquisto = (SELECT MAX(a2.DataAcquisto)
						 FROM FornituraProdGrezzo as f2, Acquisizione as a2
						 WHERE f2.IdA = a2.IdA);

-- Operazione 19
SELECT s1.NomeCatena, SUM(p1.RicavoTotale) as RicavoCatena
FROM Supermercato as s1, Supermercato as s2, ProdottiInSupermercato as p1
WHERE s1.IdS = s2.IdS AND s1.IdS = p1.IdS
GROUP BY s1.NomeCatena
HAVING RicavoCatena >= (SELECT SUM(p2.RicavoTotale)
						FROM ProdottiInSupermercato as p2, Supermercato as s2
						WHERE p2.IdS = s2.IdS AND s2.NomeCatena = "Lidl");
                        


-- Operazione 19 VIEW
SELECT s.NomeCatena, SUM(s.RicavoTotale) as RicavoCatena
FROM SupNomeCIdSGDistrNomeProdMarchioQuantQuantVRicavoTot as s, Supermercato as s2
WHERE s.IdS = s2.IdS
GROUP BY s.NomeCatena
HAVING RicavoCatena >= (SELECT SUM(p2.RicavoTotale)
						FROM ProdottiInSupermercato as p2, Supermercato as s2
						WHERE p2.IdS = s2.IdS AND s2.NomeCatena = "Lidl");






