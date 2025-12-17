DROP TABLE IF EXISTS reponse;
DROP TABLE IF EXISTS commentaire;
DROP TABLE IF EXISTS choix_sondage;
DROP TABLE IF EXISTS sondage;
DROP TABLE IF EXISTS participation_event;
DROP TABLE IF EXISTS participation_membre;
DROP TABLE IF EXISTS mission_progress;
DROP TABLE IF EXISTS competition;
DROP TABLE IF EXISTS saison;
DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS commande;
DROP TABLE IF EXISTS produit;
DROP TABLE IF EXISTS evenement;
DROP TABLE IF EXISTS categorie;
DROP TABLE IF EXISTS club;
DROP TABLE IF EXISTS user;

-- User Table (with all fields from User.java)
CREATE TABLE user (
    id INT PRIMARY KEY AUTO_INCREMENT,
    prenom VARCHAR(50) NOT NULL,
    nom VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(30),
    tel VARCHAR(20) UNIQUE NOT NULL,
    profile_picture VARCHAR(255),
    status VARCHAR(20) DEFAULT 'active',
    is_verified BOOLEAN DEFAULT FALSE,
    confirmation_token VARCHAR(100),
    confirmation_token_expires_at DATETIME,
    created_at DATETIME,
    last_login_at DATETIME,
    warning_count INT DEFAULT 0,
    verification_attempts INT DEFAULT 0,
    last_code_sent_time DATETIME
);

-- Club Table (with all fields from Club.java)
CREATE TABLE club (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(100),
    nom_c VARCHAR(100),
    description TEXT,
    logo VARCHAR(255),
    date_creation DATETIME,
    president_id INT,
    status VARCHAR(20),
    image VARCHAR(255),
    points INT DEFAULT 0,
    FOREIGN KEY (president_id) REFERENCES user(id)
);

-- ParticipationMembre Table (with all fields from ParticipationMembre.java)
CREATE TABLE participation_membre (
    id INT PRIMARY KEY AUTO_INCREMENT,
    date_request DATETIME,
    statut VARCHAR(20),
    user_id INT,
    club_id INT,
    description TEXT,
    FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE,
    FOREIGN KEY (club_id) REFERENCES club(id) ON DELETE CASCADE
);

-- Categorie Table
CREATE TABLE categorie (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom_cat VARCHAR(100)
);

-- Evenement Table
CREATE TABLE evenement (
    id INT PRIMARY KEY AUTO_INCREMENT,
    club_id INT,
    categorie_id INT,
    nom_event VARCHAR(100),
    type VARCHAR(50),
    desc_event TEXT,
    image_description VARCHAR(255),
    start_date DATETIME,
    end_date DATETIME,
    lieux VARCHAR(100),
    FOREIGN KEY (club_id) REFERENCES club(id) ON DELETE CASCADE,
    FOREIGN KEY (categorie_id) REFERENCES categorie(id)
);

-- Participation_event Table
CREATE TABLE participation_event (
    user_id INT,
    evenement_id INT,
    date_participation DATETIME,
    PRIMARY KEY (user_id, evenement_id),
    FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE,
    FOREIGN KEY (evenement_id) REFERENCES evenement(id) ON DELETE CASCADE
);

-- Produit Table (with all fields from Produit.java)
CREATE TABLE produit (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom_prod VARCHAR(100),
    desc_prod TEXT,
    prix FLOAT,
    img_prod VARCHAR(255),
    created_at DATETIME,
    quantity VARCHAR(20),
    club_id INT,
    FOREIGN KEY (club_id) REFERENCES club(id) ON DELETE CASCADE
);

-- Commande Table (with all fields from Commande.java)
CREATE TABLE commande (
    id INT PRIMARY KEY AUTO_INCREMENT,
    date_comm DATE,
    statut VARCHAR(20),
    user_id INT,
    total DOUBLE,
    FOREIGN KEY (user_id) REFERENCES user(id)
);

-- Order_details Table (with all fields from Orderdetails.java)
CREATE TABLE order_details (
    id INT PRIMARY KEY AUTO_INCREMENT,
    commande_id INT,
    produit_id INT,
    quantity INT,
    price DOUBLE,
    total DOUBLE,
    FOREIGN KEY (commande_id) REFERENCES commande(id) ON DELETE CASCADE,
    FOREIGN KEY (produit_id) REFERENCES produit(id)
);

-- Saison Table (with all fields from Saison.java)
CREATE TABLE saison (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom_saison VARCHAR(100),
    desc_saison TEXT,
    date_fin DATE,
    image VARCHAR(255),
    updated_at DATE
);

-- Competition Table (with all fields from Competition.java)
CREATE TABLE competition (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom_comp VARCHAR(100),
    desc_comp TEXT,
    points INT,
    start_date DATETIME,
    end_date DATETIME,
    goal_type VARCHAR(30),
    goal_value INT,
    saison_id INT,
    status VARCHAR(20),
    FOREIGN KEY (saison_id) REFERENCES saison(id) ON DELETE CASCADE
);

-- MissionProgress Table (from MissionProgress.java - was missing entirely)
CREATE TABLE mission_progress (
    id INT PRIMARY KEY AUTO_INCREMENT,
    club_id INT NOT NULL,
    competition_id INT NOT NULL,
    progress INT DEFAULT 0,
    is_completed BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (club_id) REFERENCES club(id) ON DELETE CASCADE,
    FOREIGN KEY (competition_id) REFERENCES competition(id) ON DELETE CASCADE,
    UNIQUE KEY unique_club_competition (club_id, competition_id)
);

-- Sondage Table (with all fields from Sondage.java)
CREATE TABLE sondage (
    id INT PRIMARY KEY AUTO_INCREMENT,
    question TEXT,
    created_at DATETIME,
    user_id INT,
    club_id INT,
    FOREIGN KEY (user_id) REFERENCES user(id),
    FOREIGN KEY (club_id) REFERENCES club(id) ON DELETE CASCADE
);

-- ChoixSondage Table (with all fields from ChoixSondage.java)
CREATE TABLE choix_sondage (
    id INT PRIMARY KEY AUTO_INCREMENT,
    contenu VARCHAR(255),
    sondage_id INT,
    FOREIGN KEY (sondage_id) REFERENCES sondage(id) ON DELETE CASCADE
);

-- Commentaire Table (with all fields from Commentaire.java)
CREATE TABLE commentaire (
    id INT PRIMARY KEY AUTO_INCREMENT,
    contenu_comment TEXT,
    date_comment DATE,
    user_id INT,
    sondage_id INT,
    FOREIGN KEY (user_id) REFERENCES user(id),
    FOREIGN KEY (sondage_id) REFERENCES sondage(id) ON DELETE CASCADE
);

-- Reponse Table (with all fields from Reponse.java)
CREATE TABLE reponse (
    id INT PRIMARY KEY AUTO_INCREMENT,
    date_reponse DATETIME,
    user_id INT,
    choix_id INT,
    sondage_id INT,
    FOREIGN KEY (user_id) REFERENCES user(id),
    FOREIGN KEY (choix_id) REFERENCES choix_sondage(id) ON DELETE CASCADE,
    FOREIGN KEY (sondage_id) REFERENCES sondage(id) ON DELETE CASCADE
);

-- =============================================
-- ENRICHED TEST DATA
-- =============================================

-- Users (covering all roles and statuses)
INSERT INTO user (prenom, nom, email, password, role, tel, profile_picture, status, is_verified, confirmation_token, confirmation_token_expires_at, created_at, last_login_at, warning_count, verification_attempts, last_code_sent_time) VALUES
-- Administrators
('Alice', 'Dubois', 'alice.dubois@university.tn', '$2a$10$hashedpassword1', 'ADMINISTRATEUR', '+21612345001', 'profiles/alice.jpg', 'active', TRUE, NULL, NULL, '2025-08-01 10:00:00', '2025-12-17 08:30:00', 0, 0, NULL),
('Mohamed', 'Ben Salem', 'mohamed.bensalem@university.tn', '$2a$10$hashedpassword2', 'ADMINISTRATEUR', '+21698765001', 'profiles/mohamed.jpg', 'active', TRUE, NULL, NULL, '2025-08-01 10:30:00', '2025-12-16 14:20:00', 0, 0, NULL),

-- Club Presidents
('Sarah', 'Trabelsi', 'sarah.trabelsi@university.tn', '$2a$10$hashedpassword3', 'PRESIDENT_CLUB', '+21623456001', 'profiles/sarah.jpg', 'active', TRUE, NULL, NULL, '2025-08-15 09:00:00', '2025-12-17 07:45:00', 0, 0, NULL),
('Karim', 'Hamdi', 'karim.hamdi@university.tn', '$2a$10$hashedpassword4', 'PRESIDENT_CLUB', '+21634567001', 'profiles/karim.jpg', 'active', TRUE, NULL, NULL, '2025-08-15 09:30:00', '2025-12-16 18:30:00', 0, 0, NULL),
('Leila', 'Gharbi', 'leila.gharbi@university.tn', '$2a$10$hashedpassword5', 'PRESIDENT_CLUB', '+21645678001', 'profiles/leila.jpg', 'active', TRUE, NULL, NULL, '2025-08-15 10:00:00', '2025-12-15 16:20:00', 0, 0, NULL),
('Youssef', 'Khelifi', 'youssef.khelifi@university.tn', '$2a$10$hashedpassword6', 'PRESIDENT_CLUB', '+21656789001', 'profiles/youssef.jpg', 'active', TRUE, NULL, NULL, '2025-08-15 10:30:00', '2025-12-17 09:10:00', 0, 0, NULL),
('Amira', 'Messaoudi', 'amira.messaoudi@university.tn', '$2a$10$hashedpassword7', 'PRESIDENT_CLUB', '+21667890001', 'profiles/amira.jpg', 'active', TRUE, NULL, NULL, '2025-08-15 11:00:00', '2025-12-16 11:45:00', 0, 0, NULL),
('Mehdi', 'Bouazizi', 'mehdi.bouazizi@university.tn', '$2a$10$hashedpassword8', 'PRESIDENT_CLUB', '+21678901001', NULL, 'active', TRUE, NULL, NULL, '2025-08-15 11:30:00', '2025-12-15 20:30:00', 0, 0, NULL),

-- Active Members
('Fatma', 'Jebali', 'fatma.jebali@university.tn', '$2a$10$hashedpassword9', 'MEMBRE', '+21689012001', 'profiles/fatma.jpg', 'active', TRUE, NULL, NULL, '2025-09-01 10:00:00', '2025-12-17 08:00:00', 0, 0, NULL),
('Omar', 'Nasri', 'omar.nasri@university.tn', '$2a$10$hashedpassword10', 'MEMBRE', '+21690123001', 'profiles/omar.jpg', 'active', TRUE, NULL, NULL, '2025-09-01 10:30:00', '2025-12-16 15:30:00', 0, 0, NULL),
('Salma', 'Riahi', 'salma.riahi@university.tn', '$2a$10$hashedpassword11', 'MEMBRE', '+21601234001', 'profiles/salma.jpg', 'active', TRUE, NULL, NULL, '2025-09-01 11:00:00', '2025-12-17 07:15:00', 0, 0, NULL),
('Ahmed', 'Bouslama', 'ahmed.bouslama@university.tn', '$2a$10$hashedpassword12', 'MEMBRE', '+21612345002', NULL, 'active', TRUE, NULL, NULL, '2025-09-01 11:30:00', '2025-12-16 19:20:00', 0, 0, NULL),
('Nour', 'Chakroun', 'nour.chakroun@university.tn', '$2a$10$hashedpassword13', 'MEMBRE', '+21623456002', 'profiles/nour.jpg', 'active', TRUE, NULL, NULL, '2025-09-01 12:00:00', '2025-12-15 13:45:00', 0, 0, NULL),
('Rami', 'Ferchichi', 'rami.ferchichi@university.tn', '$2a$10$hashedpassword14', 'MEMBRE', '+21634567002', 'profiles/rami.jpg', 'active', TRUE, NULL, NULL, '2025-09-01 12:30:00', '2025-12-17 09:30:00', 0, 0, NULL),
('Ines', 'Mansour', 'ines.mansour@university.tn', '$2a$10$hashedpassword15', 'MEMBRE', '+21645678002', NULL, 'active', TRUE, NULL, NULL, '2025-09-01 13:00:00', '2025-12-16 10:15:00', 0, 0, NULL),
('Khalil', 'Zaouali', 'khalil.zaouali@university.tn', '$2a$10$hashedpassword16', 'MEMBRE', '+21656789002', 'profiles/khalil.jpg', 'active', TRUE, NULL, NULL, '2025-09-01 13:30:00', '2025-12-15 17:20:00', 0, 0, NULL),
('Mariem', 'Slimani', 'mariem.slimani@university.tn', '$2a$10$hashedpassword17', 'MEMBRE', '+21667890002', 'profiles/mariem.jpg', 'active', TRUE, NULL, NULL, '2025-09-01 14:00:00', '2025-12-17 08:45:00', 0, 0, NULL),
('Sami', 'Oueslati', 'sami.oueslati@university.tn', '$2a$10$hashedpassword18', 'MEMBRE', '+21678901002', NULL, 'active', TRUE, NULL, NULL, '2025-09-01 14:30:00', '2025-12-16 16:40:00', 0, 0, NULL),
('Houda', 'Dridi', 'houda.dridi@university.tn', '$2a$10$hashedpassword19', 'MEMBRE', '+21689012002', 'profiles/houda.jpg', 'active', TRUE, NULL, NULL, '2025-09-01 15:00:00', '2025-12-15 12:30:00', 0, 0, NULL),
('Bilel', 'Sassi', 'bilel.sassi@university.tn', '$2a$10$hashedpassword20', 'MEMBRE', '+21690123002', 'profiles/bilel.jpg', 'active', TRUE, NULL, NULL, '2025-09-01 15:30:00', '2025-12-17 10:20:00', 0, 0, NULL),

-- Inactive/Suspended Members
('Asma', 'Chatti', 'asma.chatti@university.tn', '$2a$10$hashedpassword21', 'MEMBRE', '+21601234002', NULL, 'suspended', TRUE, NULL, NULL, '2025-09-15 10:00:00', '2025-11-20 14:30:00', 3, 0, NULL),
('Hichem', 'Gharbi', 'hichem.gharbi@university.tn', '$2a$10$hashedpassword22', 'MEMBRE', '+21612345003', NULL, 'inactive', TRUE, NULL, NULL, '2025-09-15 10:30:00', '2025-10-05 09:15:00', 0, 0, NULL),

-- Unverified Users
('Dorra', 'Ayari', 'dorra.ayari@university.tn', '$2a$10$hashedpassword23', 'MEMBRE', '+21623456003', NULL, 'active', FALSE, 'token123abc', '2025-12-18 10:00:00', '2025-12-16 10:00:00','2025-12-16 10:00:00', 0, 1, '2025-12-16 10:00:00'),
('Tarek', 'Mzoughi', 'tarek.mzoughi@university.tn', '$2a$10$hashedpassword24', 'MEMBRE', '+21634567003', NULL, 'active', FALSE, 'token456def', '2025-12-19 15:00:00', '2025-12-16 15:00:00','2025-12-16 10:00:00', 0, 2, '2025-12-16 15:00:00');


-- Clubs (covering different statuses and points)
INSERT INTO club (nom, nom_c, description, logo, date_creation, president_id, status, image, points) VALUES
('Club Informatique et Technologies', 'InfoTech', 'Club dédié aux passionnés de programmation, IA, cybersécurité et nouvelles technologies', 'logos/infotech.png', '2024-09-15 10:00:00', 3, 'active', 'banners/infotech_banner.jpg', 350),
('Club Sportif Universitaire', 'CSU', 'Club omnisports : football, basketball, volleyball, athlétisme', 'logos/csu.png', '2024-09-20 14:30:00', 4, 'active', 'banners/csu_banner.jpg', 280),
('Club Théâtre et Arts Dramatiques', 'ThéâtrePlus', 'Club de théâtre, improvisation et arts de la scène', 'logos/theatre.png', '2024-10-01 11:00:00', 5, 'active', 'banners/theatre_banner.jpg', 220),
('Club Entrepreneuriat et Innovation', 'StartUp Lab', 'Club pour développer l''esprit entrepreneurial et l''innovation', 'logos/startup.png', '2024-10-10 09:00:00', 6, 'active', 'banners/startup_banner.jpg', 310),
('Club Environnement et Développement Durable', 'Green Campus', 'Club écologique pour un campus plus vert', 'logos/green.png', '2024-10-15 13:00:00', 7, 'active', 'banners/green_banner.jpg', 190),
('Club Musique et Chant', 'Harmony', 'Club de musique, chant choral et concerts', 'logos/music.png', '2024-11-01 15:00:00', 8, 'active', 'banners/music_banner.jpg', 245),
('Club Photographie', 'PhotoArt', 'Club de photographie et arts visuels', 'logos/photo.png', '2025-01-10 10:30:00', 3, 'pending', 'banners/photo_banner.jpg', 50),
('Club Robotique', 'RoboClub', 'Club de robotique et électronique', 'logos/robo.png', '2025-02-01 16:00:00', 4, 'inactive', NULL, 20);

-- Categories
INSERT INTO categorie (nom_cat) VALUES 
('Informatique et Technologie'),
('Sport et Bien-être'),
('Culture et Arts'),
('Science et Innovation'),
('Social et Humanitaire'),
('Entrepreneuriat'),
('Environnement');

-- ParticipationMembre (covering all statuses)
INSERT INTO participation_membre (date_request, statut, user_id, club_id, description) VALUES
-- Accepted members
('2025-09-20 10:00:00', 'accepte', 9, 1, 'Développeur passionné par l''IA'),
('2025-09-21 11:30:00', 'accepte', 10, 1, 'Expert en cybersécurité'),
('2025-09-22 14:00:00', 'accepte', 11, 1, 'Développeur full-stack'),
('2025-09-25 09:00:00', 'accepte', 12, 2, 'Joueur de football'),
('2025-09-26 10:30:00', 'accepte', 13, 2, 'Basketteur'),
('2025-09-27 15:00:00', 'accepte', 14, 2, 'Athlète confirmé'),
('2025-10-05 11:00:00', 'accepte', 15, 3, 'Comédien amateur'),
('2025-10-06 13:30:00', 'accepte', 16, 3, 'Passionné d''improvisation'),
('2025-10-12 10:00:00', 'accepte', 17, 4, 'Porteur de projet startup'),
('2025-10-13 14:00:00', 'accepte', 18, 4, 'Designer UI/UX'),
('2025-10-18 09:30:00', 'accepte', 19, 5, 'Militant écologique'),
('2025-11-03 11:00:00', 'accepte', 20, 6, 'Chanteur et guitariste'),
('2025-09-28 16:00:00', 'accepte', 10, 2, 'Fan de volleyball'),
('2025-10-15 12:00:00', 'accepte', 11, 4, 'Intéressé par le marketing digital'),
('2025-11-10 10:00:00', 'accepte', 12, 5, 'Volontaire pour actions écologiques'),

-- Pending requests
('2025-12-10 10:00:00', 'en_attente', 21, 1, 'Étudiant en informatique, souhaite rejoindre'),
('2025-12-11 11:00:00', 'en_attente', 22, 2, 'Amateur de sport'),
('2025-12-12 14:30:00', 'en_attente', 23, 3, 'Débutant en théâtre'),
('2025-12-13 09:00:00', 'en_attente', 24, 1, 'Passionné par le développement web'),

-- Rejected requests
('2025-11-20 10:00:00', 'refuse', 21, 2, 'Pas de disponibilité pour les entraînements'),
('2025-11-25 15:00:00', 'refuse', 22, 3, 'Profil ne correspond pas aux attentes du club');

-- Evenements (past, ongoing, and future events)
INSERT INTO evenement (club_id, categorie_id, nom_event, type, desc_event, image_description, start_date, end_date, lieux) VALUES
-- Past events
(1, 1, 'Hackathon Intelligence Artificielle 2025', 'Compétition', 'Concours de développement d''applications IA en 24h', 'events/hackathon_ia.jpg', '2025-11-15 09:00:00', '2025-11-16 09:00:00', 'Amphithéâtre A'),
(2, 2, 'Tournoi Inter-Universitaire de Football', 'Tournoi', 'Compétition de football entre universités', 'events/tournoi_foot.jpg', '2025-10-20 08:00:00', '2025-10-22 18:00:00', 'Stade Municipal'),
(3, 3, 'Festival de Théâtre Universitaire', 'Festival', 'Trois jours de représentations théâtrales', 'events/festival_theatre.jpg', '2025-11-01 19:00:00', '2025-11-03 22:00:00', 'Théâtre Municipal'),
(5, 7, 'Journée de Nettoyage du Campus', 'Action Sociale', 'Action de nettoyage et sensibilisation environnementale', 'events/clean_campus.jpg', '2025-10-15 08:00:00', '2025-10-15 13:00:00', 'Campus Universitaire'),

-- Ongoing events
(4, 6, 'Bootcamp Entrepreneuriat', 'Formation', 'Programme intensif de 2 semaines pour créer sa startup', 'events/bootcamp.jpg', '2025-12-01 09:00:00', '2025-12-15 17:00:00', 'Salle Innovation Hub'),
(6, 3, 'Concert de Fin d''Année', 'Concert', 'Grand concert avec plusieurs groupes étudiants', 'events/concert.jpg', '2025-12-17 19:00:00', '2025-12-17 23:00:00', 'Salle des Fêtes'),

-- Future events
(1, 1, 'Conférence Cybersécurité', 'Conférence', 'Conférence sur les dernières tendances en cybersécurité', 'events/cyber_conf.jpg', '2025-01-20 14:00:00', '2025-01-20 17:00:00', 'Amphithéâtre B'),
(2, 2, 'Marathon Universitaire', 'Compétition', 'Course de marathon ouvert à tous les étudiants', 'events/marathon.jpg', '2025-02-10 07:00:00', '2025-02-10 14:00:00', 'Parc Urbain'),
(3, 3, 'Atelier d''Improvisation', 'Atelier', 'Initiation à l''improvisation théâtrale', 'events/impro.jpg', '2025-01-15 18:00:00', '2025-01-15 21:00:00', 'Salle Polyvalente'),
(4, 6, 'Pitch Competition', 'Compétition', 'Compétition de pitch pour startups étudiantes', 'events/pitch.jpg', '2025-02-25 10:00:00', '2025-02-25 18:00:00', 'Auditorium Principal'),
(5, 7, 'Plantation d''Arbres', 'Action Sociale', 'Plantation de 100 arbres dans le campus', 'events/plantation.jpg', '2025-03-21 08:00:00', '2025-03-21 12:00:00', 'Espace Vert Campus'),
(6, 3, 'Battle de Rap', 'Compétition', 'Compétition de rap entre étudiants', 'events/rap_battle.jpg', '2025-02-14 20:00:00', '2025-02-14 23:30:00', 'Club Universitaire'),
(1, 1, 'Atelier Python Avancé', 'Atelier', 'Formation avancée sur Python et data science', 'events/python_workshop.jpg', '2025-01-25 14:00:00', '2025-01-27 17:00:00', 'Laboratoire Informatique'),
(2, 2, 'Championnat de Basketball 3x3', 'Tournoi', 'Tournoi de basketball en format 3 contre 3', 'events/basket_3x3.jpg', '2025-03-05 09:00:00', '2025-03-07 18:00:00', 'Terrain de Basketball');

-- Participation_event (realistic participation patterns)
INSERT INTO participation_event (user_id, evenement_id, date_participation) VALUES
-- Hackathon IA
(9, 1, '2025-11-10 14:00:00'),
(10, 1, '2025-11-12 10:00:00'),
(11, 1, '2025-11-11 16:00:00'),
(17, 1, '2025-11-13 09:00:00'),
(18, 1, '2025-11-14 11:00:00'),

-- Tournoi Football
(12, 2, '2025-10-15 10:00:00'),
(13, 2, '2025-10-16 14:00:00'),
(14, 2, '2025-10-17 11:00:00'),
(10, 2, '2025-10-18 15:00:00'),

-- Festival Théâtre
(15, 3, '2025-10-25 18:00:00'),
(16, 3, '2025-10-26 17:00:00'),
(20, 3, '2025-10-28 19:00:00'),

-- Nettoyage Campus
(19, 4, '2025-10-10 08:00:00'),
(12, 4, '2025-10-11 09:00:00'),
(11, 4, '2025-10-12 08:30:00'),
(15, 4, '2025-10-13 09:00:00'),
(9, 4, '2025-10-14 08:00:00'),

-- Bootcamp Entrepreneuriat (ongoing)
(17, 5, '2025-11-25 10:00:00'),
(18, 5, '2025-11-26 11:00:00'),
(11, 5, '2025-11-27 09:30:00'),

-- Concert (today)
(20, 6, '2025-12-15 14:00:00'),
(16, 6, '2025-12-16 15:00:00'),
(15, 6, '2025-12-16 16:00:00'),

-- Future events registrations
(9, 7, '2025-12-10 10:00:00'),
(10, 7, '2025-12-11 11:00:00'),
(11, 7, '2025-12-12 14:00:00'),
(12, 8, '2025-12-05 09:00:00'),
(13, 8, '2025-12-06 10:00:00'),
(14, 8, '2025-12-07 11:00:00'),
(15, 9, '2025-12-08 15:00:00'),
(16, 9, '2025-12-09 16:00:00'),
(17, 10, '2025-12-10 12:00:00'),
(18, 10, '2025-12-11 13:00:00'),
(19, 11, '2025-12-12 14:00:00'),
(20, 12, '2025-12-13 10:00:00'),
(9, 13, '2025-12-14 11:00:00'),
(10, 13, '2025-12-15 12:00:00'),
(11, 13, '2025-12-16 13:00:00'),
(12, 14, '2025-12-14 15:00:00'),
(13, 14, '2025-12-15 16:00:00');

-- Produits (merchandise from different clubs, various stock levels)
INSERT INTO produit (nom_prod, desc_prod, prix, img_prod, created_at, quantity, club_id) VALUES
-- Club Informatique
('T-shirt InfoTech 2025', 'T-shirt noir avec logo du club en blanc, 100% coton', 25.00, 'products/tshirt_infotech.jpg', '2025-09-20 10:00:00', '45', 1),
('Hoodie InfoTech', 'Sweat à capuche gris avec logo brodé', 55.00, 'products/hoodie_infotech.jpg', '2025-09-25 11:00:00', '20', 1),
('Casquette InfoTech', 'Casquette noire ajustable avec logo', 18.00, 'products/cap_infotech.jpg', '2025-10-01 12:00:00', '30', 1),
('Stickers Pack InfoTech', 'Pack de 10 stickers variés', 5.00, 'products/stickers_infotech.jpg', '2025-10-05 14:00:00', '100', 1),
('Clé USB 32GB InfoTech', 'Clé USB personnalisée avec logo du club', 15.00, 'products/usb_infotech.jpg', '2025-10-10 09:00:00', '0', 1),

-- Club Sportif
('Maillot CSU Home', 'Maillot de football domicile, plusieurs tailles', 35.00, 'products/jersey_csu_home.jpg', '2025-09-22 10:00:00', '60', 2),
('Maillot CSU Away', 'Maillot de football extérieur, plusieurs tailles', 35.00, 'products/jersey_csu_away.jpg', '2025-09-22 10:30:00', '40', 2),
('Short de Sport CSU', 'Short de sport respirant', 22.00, 'products/shorts_csu.jpg', '2025-09-28 11:00:00', '35', 2),
('Ballon de Football CSU', 'Ballon officiel taille 5', 30.00, 'products/ball_csu.jpg', '2025-10-02 14:00:00', '15', 2),
('Gourde CSU', 'Gourde isotherme 750ml', 20.00, 'products/bottle_csu.jpg', '2025-10-08 10:00:00', '50', 2),
('Sac de Sport CSU', 'Sac de sport grande capacité', 45.00, 'products/bag_csu.jpg', '2025-10-15 11:00:00', '25', 2),

-- Club Théâtre
('T-shirt ThéâtrePlus', 'T-shirt blanc avec citation théâtrale', 23.00, 'products/tshirt_theatre.jpg', '2025-10-05 10:00:00', '40', 3),
('Tote Bag ThéâtrePlus', 'Sac en toile réutilisable', 12.00, 'products/totebag_theatre.jpg', '2025-10-10 11:00:00', '55', 3),
('Affiche Festival 2025', 'Affiche collector du festival', 8.00, 'products/poster_theatre.jpg', '2025-11-01 14:00:00', '30', 3),

-- Club Entrepreneuriat
('T-shirt StartUp Lab', 'T-shirt premium avec slogan motivant', 28.00, 'products/tshirt_startup.jpg', '2025-10-12 10:00:00', '35', 4),
('Carnet de Notes StartUp Lab', 'Carnet moleskine personnalisé', 15.00, 'products/notebook_startup.jpg', '2025-10-15 11:00:00', '50', 4),
('Stylo Luxe StartUp Lab', 'Stylo métallique avec gravure', 25.00, 'products/pen_startup.jpg', '2025-10-20 12:00:00', '20', 4),

-- Club Environnement
('T-shirt Bio Green Campus', 'T-shirt 100% coton bio', 30.00, 'products/tshirt_green.jpg', '2025-10-18 10:00:00', '40', 5),
('Gourde Écologique', 'Gourde en inox réutilisable 1L', 22.00, 'products/bottle_green.jpg', '2025-10-22 11:00:00', '45', 5),
('Sac Shopping Réutilisable', 'Sac shopping en coton bio', 10.00, 'products/bag_green.jpg', '2025-10-25 12:00:00', '60', 5),
('Graines à Planter', 'Kit de graines bio variées', 8.00, 'products/seeds_green.jpg', '2025-11-01 10:00:00', '75', 5),

-- Club Musique
('T-shirt Harmony', 'T-shirt avec design musical', 24.00, 'products/tshirt_harmony.jpg', '2025-11-05 10:00:00', '35', 6),
('Album CD Harmony Live', 'Enregistrement du concert 2024', 12.00, 'products/cd_harmony.jpg', '2025-11-10 11:00:00', '40', 6),
('Médiators Personnalisés', 'Set de 5 médiators avec logo', 6.00, 'products/picks_harmony.jpg', '2025-11-12 14:00:00', '80', 6);

-- Commandes (various statuses and time periods)
INSERT INTO commande (date_comm, statut, user_id, total) VALUES
-- Completed orders
('2025-10-15', 'LIVREE', 9, 80.00),
('2025-10-20', 'LIVREE', 10, 53.00),
('2025-11-01', 'LIVREE', 11, 105.00),
('2025-11-05', 'LIVREE', 12, 70.00),
('2025-11-10', 'LIVREE', 13, 35.00),
('2025-11-15', 'LIVREE', 14, 92.00),
('2025-11-20', 'LIVREE', 15, 35.00),
('2025-11-25', 'LIVREE', 16, 22.00),

-- Confirmed orders
('2025-12-01', 'CONFIRMEE', 17, 55.00),
('2025-12-03', 'CONFIRMEE', 18, 90.00),
('2025-12-05', 'CONFIRMEE', 19, 52.00),
('2025-12-08', 'CONFIRMEE', 20, 48.00),

-- Orders in progress
('2025-12-12', 'EN_COURS', 9, 67.00),
('2025-12-14', 'EN_COURS', 10, 120.00),
('2025-12-15', 'EN_COURS', 11, 43.00),
('2025-12-16', 'EN_COURS', 12, 85.00),

-- Pending orders
('2025-12-17', 'EN_ATTENTE', 13, 75.00),
('2025-12-17', 'EN_ATTENTE', 14, 30.00),

-- Cancelled orders
('2025-11-08', 'ANNULEE', 15, 45.00),
('2025-11-22', 'ANNULEE', 16, 60.00);

-- Order_details (detailed order items)
INSERT INTO order_details (commande_id, produit_id, quantity, price, total) VALUES
-- Order 1 (user 9)
(1, 1, 2, 25.00, 50.00),
(1, 4, 6, 5.00, 30.00),

-- Order 2 (user 10)
(2, 6, 1, 35.00, 35.00),
(2, 10, 1, 18.00, 18.00),

-- Order 3 (user 11)
(3, 2, 1, 55.00, 55.00),
(3, 1, 2, 25.00, 50.00),

-- Order 4 (user 12)
(4, 6, 2, 35.00, 70.00),

-- Order 5 (user 13)
(5, 7, 1, 35.00, 35.00),

-- Order 6 (user 14)
(6, 11, 2, 45.00, 90.00),
(6, 13, 1, 2.00, 2.00),

-- Order 7 (user 15)
(7, 14, 1, 23.00, 23.00),
(7, 15, 1, 12.00, 12.00),

-- Order 8 (user 16)
(8, 8, 1, 22.00, 22.00),

-- Order 9 (user 17 - confirmed)
(9, 2, 1, 55.00, 55.00),

-- Order 10 (user 18 - confirmed)
(10, 11, 2, 45.00, 90.00),

-- Order 11 (user 19 - confirmed)
(11, 18, 2, 22.00, 44.00),
(11, 20, 1, 8.00, 8.00),

-- Order 12 (user 20 - confirmed)
(12, 21, 2, 24.00, 48.00),

-- Order 13 (user 9 - in progress)
(13, 16, 1, 28.00, 28.00),
(13, 17, 1, 15.00, 15.00),
(13, 21, 1, 24.00, 24.00),

-- Order 14 (user 10 - in progress)
(14, 2, 2, 55.00, 110.00),
(14, 3, 1, 10.00, 10.00),

-- Order 15 (user 11 - in progress)
(15, 18, 1, 30.00, 30.00),
(15, 15, 1, 13.00, 13.00),

-- Order 16 (user 12 - in progress)
(16, 9, 2, 30.00, 60.00),
(16, 10, 1, 25.00, 25.00),

-- Order 17 (user 13 - pending)
(17, 1, 3, 25.00, 75.00),

-- Order 18 (user 14 - pending)
(18, 19, 3, 10.00, 30.00),

-- Order 19 (user 15 - cancelled)
(19, 11, 1, 45.00, 45.00),

-- Order 20 (user 16 - cancelled)
(20, 6, 1, 35.00, 35.00),
(20, 7, 1, 25.00, 25.00);

-- Saison (multiple seasons)
INSERT INTO saison (nom_saison, desc_saison, date_fin, image, updated_at) VALUES
('Saison 2024-2025', 'Première saison du système de compétition inter-clubs', '2025-06-30', 'seasons/season_2024_2025.jpg', '2025-06-15'),
('Saison 2025-2025', 'Saison actuelle avec nouvelles compétitions et défis', '2025-06-30', 'seasons/season_2025_2025.jpg', '2025-09-01'),
('Saison 2025-2026', 'Prochaine saison en préparation', '2026-06-30', 'seasons/season_2025_2026.jpg', '2025-06-01');

-- Competition (past, current, and future competitions)
INSERT INTO competition (nom_comp, desc_comp, points, start_date, end_date, goal_type, goal_value, saison_id, status) VALUES
-- Season 1 competitions (completed)
('Compétition Hackathon Automne 2024', 'Première compétition de hackathon de la saison', 150, '2024-10-01 00:00:00', '2024-12-31 23:59:59', 'EVENT_COUNT', 5, 1, 'terminee'),
('Challenge Sportif Hiver 2025', 'Compétition basée sur la participation aux événements sportifs', 200, '2025-01-01 00:00:00', '2025-03-31 23:59:59', 'PARTICIPATION_COUNT', 100, 1, 'terminee'),
('Festival Arts & Culture Printemps 2025', 'Compétition culturelle de fin de saison', 180, '2025-04-01 00:00:00', '2025-06-30 23:59:59', 'EVENT_COUNT', 8, 1, 'terminee'),

-- Season 2 competitions (current)
('Grand Challenge Innovation 2025', 'Compétition d''innovation et entrepreneuriat', 250, '2025-09-01 00:00:00', '2025-12-31 23:59:59', 'POINTS', 500, 2, 'active'),
('Défi Environnemental Automne', 'Actions écologiques et sensibilisation', 150, '2025-10-01 00:00:00', '2025-12-31 23:59:59', 'PARTICIPATION_COUNT', 150, 2, 'active'),
('Tournoi Multi-Sports Hiver 2025', 'Compétition sportive inter-clubs', 200, '2025-01-01 00:00:00', '2025-03-31 23:59:59', 'EVENT_COUNT', 10, 2, 'a_venir'),
('Marathon Culturel Printemps 2025', 'Série d''événements culturels et artistiques', 180, '2025-04-01 00:00:00', '2025-06-30 23:59:59', 'EVENT_COUNT', 12, 2, 'a_venir'),

-- Season 3 competitions (future)
('Super Défi Tech 2025-2026', 'Grande compétition technologique annuelle', 300, '2025-09-01 00:00:00', '2026-06-30 23:59:59', 'POINTS', 1000, 3, 'a_venir');

-- Sondages (various topics and clubs)
INSERT INTO sondage (question, created_at, user_id, club_id) VALUES
('Quel langage de programmation préférez-vous pour le développement web ?', '2025-11-01 10:00:00', 3, 1),
('Quel sport devrait être ajouté au programme du club ?', '2025-11-05 14:00:00', 4, 2),
('Quelle pièce de théâtre aimeriez-vous monter cette année ?', '2025-11-10 11:00:00', 5, 3),
('Quel type d''événement vous intéresse le plus ?', '2025-11-15 09:00:00', 6, 4),
('Quelle action écologique devrait être prioritaire ?', '2025-11-20 13:00:00', 7, 5),
('Quel genre musical pour le prochain concert ?', '2025-11-25 15:00:00', 8, 6),
('Horaire préféré pour les ateliers de programmation ?', '2025-12-01 10:00:00', 3, 1),
('Fréquence idéale des entraînements sportifs ?', '2025-12-05 14:00:00', 4, 2);

-- ChoixSondage (poll choices)
INSERT INTO choix_sondage (contenu, sondage_id) VALUES
-- Sondage 1 (langages programmation)
('JavaScript', 1),
('Python', 1),
('Java', 1),
('PHP', 1),
('TypeScript', 1),

-- Sondage 2 (sports)
('Tennis', 2),
('Natation', 2),
('Badminton', 2),
('Handball', 2),

-- Sondage 3 (pièces de théâtre)
('Molière - Le Malade Imaginaire', 3),
('Shakespeare - Roméo et Juliette', 3),
('Ionesco - La Cantatrice Chauve', 3),
('Création originale', 3),

-- Sondage 4 (types événements)
('Conférences et workshops', 4),
('Compétitions et hackathons', 4),
('Networking et rencontres professionnelles', 4),
('Sorties et team building', 4),

-- Sondage 5 (actions écologiques)
('Réduction des déchets plastiques', 5),
('Plantation d''arbres', 5),
('Compostage au campus', 5),
('Sensibilisation au tri sélectif', 5),

-- Sondage 6 (genres musicaux)
('Rock', 6),
('Jazz', 6),
('Pop', 6),
('Musique traditionnelle', 6),
('Électro', 6),

-- Sondage 7 (horaires ateliers)
('Matin (8h-12h)', 7),
('Après-midi (14h-18h)', 7),
('Soir (18h-21h)', 7),
('Week-end', 7),

-- Sondage 8 (fréquence entraînements)
('2 fois par semaine', 8),
('3 fois par semaine', 8),
('Tous les jours', 8),
('Week-ends uniquement', 8);

-- Commentaires (diverse opinions)
INSERT INTO commentaire (contenu_comment, date_comment, user_id, sondage_id) VALUES
('JavaScript est très polyvalent pour le front et le back !', '2025-11-02', 9, 1),
('Python reste le meilleur pour l''IA et le machine learning', '2025-11-02', 10, 1),
('TypeScript apporte la sécurité du typage, c''est essentiel maintenant', '2025-11-03', 11, 1),
('Le tennis serait super, on pourrait utiliser les terrains municipaux', '2025-11-06', 12, 2),
('La natation c''est excellent pour la santé !', '2025-11-06', 13, 2),
('Badminton = sport accessible et convivial', '2025-11-07', 14, 2),
('Molière c''est un classique mais toujours efficace', '2025-11-11', 15, 3),
('Une création originale serait plus motivante et créative', '2025-11-11', 16, 3),
('Les workshops sont très formateurs', '2025-11-16', 17, 4),
('J''adore les hackathons, l''esprit de compétition est stimulant', '2025-11-16', 18, 4),
('Le networking est crucial pour notre future carrière', '2025-11-17', 11, 4),
('Urgent de réduire le plastique sur le campus', '2025-11-21', 19, 5),
('+1 pour la plantation d''arbres, action concrète et visible', '2025-11-21', 12, 5),
('Le compostage éduquerait tout le campus', '2025-11-22', 11, 5),
('Rock classique ou rock moderne ?', '2025-11-26', 20, 6),
('Le jazz apporterait de la classe au concert', '2025-11-26', 16, 6),
('Un mix de plusieurs genres serait idéal', '2025-11-27', 15, 6),
('Les ateliers du soir permettent à plus de monde de venir', '2025-12-02', 9, 7),
('Week-end = plus de temps pour approfondir', '2025-12-02', 10, 7),
('3 fois par semaine c''est l''équilibre parfait', '2025-12-06', 12, 8),
('Attention à ne pas surcharger l''emploi du temps des étudiants', '2025-12-06', 13, 8);

-- Reponses (poll responses from different users)
INSERT INTO reponse (date_reponse, user_id, choix_id, sondage_id) VALUES
-- Sondage 1 (langages)
('2025-11-02 10:30:00', 9, 1, 1),
('2025-11-02 11:00:00', 10, 2, 1),
('2025-11-02 14:00:00', 11, 5, 1),
('2025-11-03 09:00:00', 12, 2, 1),
('2025-11-03 10:00:00', 13, 1, 1),
('2025-11-03 11:00:00', 14, 3, 1),
('2025-11-04 15:00:00', 15, 2, 1),
('2025-11-04 16:00:00', 16, 1, 1),
('2025-11-05 09:00:00', 17, 5, 1),
('2025-11-05 10:00:00', 18, 2, 1),

-- Sondage 2 (sports)
('2025-11-06 10:00:00', 12, 6, 2),
('2025-11-06 11:00:00', 13, 7, 2),
('2025-11-06 14:00:00', 14, 8, 2),
('2025-11-07 09:00:00', 10, 6, 2),
('2025-11-07 10:00:00', 11, 7, 2),
('2025-11-07 15:00:00', 9, 8, 2),
('2025-11-08 11:00:00', 15, 6, 2),

-- Sondage 3 (théâtre)
('2025-11-11 10:00:00', 15, 10, 3),
('2025-11-11 11:00:00', 16, 12, 3),
('2025-11-12 14:00:00', 20, 11, 3),
('2025-11-12 15:00:00', 9, 12, 3),
('2025-11-13 10:00:00', 10, 10, 3),

-- Sondage 4 (événements)
('2025-11-16 10:00:00', 17, 13, 4),
('2025-11-16 11:00:00', 18, 14, 4),
('2025-11-16 14:00:00', 11, 15, 4),
('2025-11-17 09:00:00', 12, 14, 4),
('2025-11-17 10:00:00', 9, 13, 4),
('2025-11-17 15:00:00', 10, 15, 4),

-- Sondage 5 (écologie)
('2025-11-21 10:00:00', 19, 17, 5),
('2025-11-21 11:00:00', 12, 18, 5),
('2025-11-21 14:00:00', 11, 19, 5),
('2025-11-22 09:00:00', 15, 20, 5),
('2025-11-22 10:00:00', 9, 17, 5),
('2025-11-22 15:00:00', 10, 18, 5),

-- Sondage 6 (musique)
('2025-11-26 10:00:00', 20, 21, 6),
('2025-11-26 11:00:00', 16, 22, 6),
('2025-11-26 14:00:00', 15, 23, 6),
('2025-11-27 09:00:00', 9, 21, 6),
('2025-11-27 10:00:00', 10, 25, 6),

-- Sondage 7 (horaires)
('2025-12-02 10:00:00', 9, 28, 7),
('2025-12-02 11:00:00', 10, 29, 7),
('2025-12-03 14:00:00', 11, 27, 7),
('2025-12-03 15:00:00', 12, 28, 7),

-- Sondage 8 (fréquence)
('2025-12-06 10:00:00', 12, 31, 8),
('2025-12-06 11:00:00', 13, 30, 8),
('2025-12-07 09:00:00', 14, 31, 8),
('2025-12-07 10:00:00', 10, 32, 8);

-- mission progress
INSERT INTO mission_progress (club_id, competition_id, progress, is_completed) VALUES
(1, 1, 0, false),
(2, 2, 50, false),
(3, 3, 100, true),
(4, 4, 30, false),
(5, 5, 80, false),
(6, 1, 20, false),
(1, 2, 60, false),
(2, 3, 100, true),
(3, 4, 10, false),
(4, 5, 90, false);