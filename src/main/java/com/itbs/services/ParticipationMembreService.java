package com.itbs.services;

import com.itbs.models.Club;
import com.itbs.models.ParticipationMembre;
import com.itbs.models.User;
import com.itbs.utils.DataSource;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class ParticipationMembreService {
    
    private final Connection connection;
    private final UserService userService;
    private final ClubService clubService;

    public ParticipationMembreService() {
        this.connection = DataSource.getInstance().getCnx();
        this.userService = new UserService();
        this.clubService = new ClubService();
    }

    /**
     * Get all pending participation requests for a specific club
     */
    public List<ParticipationMembre> getPendingRequestsByClubId(int clubId) throws SQLException {
        List<ParticipationMembre> requests = new ArrayList<>();
        String query = "SELECT * FROM participation_membre WHERE club_id = ? AND statut = 'en_attente' ORDER BY date_request DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, clubId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                ParticipationMembre participation = extractFromResultSet(rs);
                requests.add(participation);
            }
        }
        
        return requests;
    }

    /**
     * Get all accepted members for a specific club
     */
    public List<User> getAcceptedMembersByClubId(int clubId) throws SQLException {
        List<User> members = new ArrayList<>();
        String query = "SELECT u.* FROM user u " +
                      "INNER JOIN participation_membre pm ON u.id = pm.user_id " +
                      "WHERE pm.club_id = ? AND pm.statut = 'accepte' " +
                      "ORDER BY u.nom, u.prenom";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, clubId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                User user = userService.extractUserFromResultSet(rs);
                members.add(user);
            }
        }
        
        return members;
    }

    /**
     * Get count of pending requests for a club
     */
    public int getPendingRequestsCountByClubId(int clubId) throws SQLException {
        String query = "SELECT COUNT(*) FROM participation_membre WHERE club_id = ? AND statut = 'en_attente'";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, clubId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        
        return 0;
    }

    /**
     * Get count of accepted requests for a club
     */
    public int getAcceptedRequestsCountByClubId(int clubId) throws SQLException {
        String query = "SELECT COUNT(*) FROM participation_membre WHERE club_id = ? AND statut = 'accepte'";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, clubId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        
        return 0;
    }

    /**
     * Get count of refused requests for a club
     */
    public int getRefusedRequestsCountByClubId(int clubId) throws SQLException {
        String query = "SELECT COUNT(*) FROM participation_membre WHERE club_id = ? AND statut = 'refuse'";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, clubId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        
        return 0;
    }

    /**
     * Get total count of all requests for a club
     */
    public int getTotalRequestsByClubId(int clubId) throws SQLException {
        String query = "SELECT COUNT(*) FROM participation_membre WHERE club_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, clubId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        
        return 0;
    }

    /**
     * Update participation status (accept or refuse)
     */
    public void modifier(ParticipationMembre participation) throws SQLException {
        String query = "UPDATE participation_membre SET statut = ?, description = ? WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setString(1, participation.getStatut());
            stmt.setString(2, participation.getDescription());
            stmt.setInt(3, participation.getId());
            
            stmt.executeUpdate();
        }
    }

    /**
     * Create a new participation request
     */
    public void ajouter(ParticipationMembre participation) throws SQLException {
        String query = "INSERT INTO participation_membre (date_request, statut, user_id, club_id, description) " +
                      "VALUES (?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setTimestamp(1, Timestamp.valueOf(participation.getDateRequest()));
            stmt.setString(2, participation.getStatut());
            stmt.setInt(3, participation.getUser().getId());
            stmt.setInt(4, participation.getClub().getId());
            stmt.setString(5, participation.getDescription());
            
            stmt.executeUpdate();
            
            ResultSet generatedKeys = stmt.getGeneratedKeys();
            if (generatedKeys.next()) {
                participation.setId(generatedKeys.getInt(1));
            }
        }
    }

    /**
     * Delete a participation request
     */
    public void supprimer(int id) throws SQLException {
        String query = "DELETE FROM participation_membre WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    public boolean supprimer2(int id) throws SQLException {
        String query = "DELETE FROM participation_membre WHERE id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, id);
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        }
    }

    /**
     * Get participation by ID
     */
    public ParticipationMembre getById(int id) throws SQLException {
        String query = "SELECT * FROM participation_membre WHERE id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return extractFromResultSet(rs);
            }
        }
        
        return null;
    }

    /**
     * Check if user has already requested to join a club
     */
    public boolean hasUserRequestedClub(int userId, int clubId) throws SQLException {
        String query = "SELECT COUNT(*) FROM participation_membre WHERE user_id = ? AND club_id = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, clubId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        
        return false;
    }

    /**
     * Get all participation requests for a user
     */
    public List<ParticipationMembre> getRequestsByUserId(int userId) throws SQLException {
        List<ParticipationMembre> requests = new ArrayList<>();
        String query = "SELECT * FROM participation_membre WHERE user_id = ? ORDER BY date_request DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                ParticipationMembre participation = extractFromResultSet(rs);
                requests.add(participation);
            }
        }
        
        return requests;
    }

    /**
     * Extract ParticipationMembre from ResultSet
     */
    private ParticipationMembre extractFromResultSet(ResultSet rs) throws SQLException {
        ParticipationMembre participation = new ParticipationMembre();
        
        participation.setId(rs.getInt("id"));
        
        Timestamp dateRequest = rs.getTimestamp("date_request");
        if (dateRequest != null) {
            participation.setDateRequest(dateRequest.toLocalDateTime());
        }
        
        participation.setStatut(rs.getString("statut"));
        participation.setDescription(rs.getString("description"));
        
        // Load user
        int userId = rs.getInt("user_id");
        User user = userService.getUserById(userId);
        participation.setUser(user);
        
        // Load club
        int clubId = rs.getInt("club_id");
        Club club = clubService.getClubById1(clubId);
        participation.setClub(club);
        
        return participation;
    }

    /**
     * Get all participation requests
     */
    public List<ParticipationMembre> afficher() throws SQLException {
        List<ParticipationMembre> requests = new ArrayList<>();
        String query = "SELECT * FROM participation_membre ORDER BY date_request DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                ParticipationMembre participation = extractFromResultSet(rs);
                requests.add(participation);
            }
        }
        
        return requests;
    }

        public ArrayList<ParticipationMembre> getAllParticipants() throws SQLException {
        ArrayList<ParticipationMembre> participants = new ArrayList<>();
        String query = "SELECT * FROM participation_membre ORDER BY date_request DESC";

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                ParticipationMembre participation = extractFromResultSet(rs);
                participants.add(participation);
            }
        }

        return participants;
    }

    public ArrayList<ParticipationMembre> getParticipationsByClubAndStatut(int clubId, String statut) {
        ArrayList<ParticipationMembre> participations = new ArrayList<>();
        String query = "SELECT * FROM participation_membre WHERE club_id = ? AND statut = ?";

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, clubId);
            stmt.setString(2, statut);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                ParticipationMembre participation = extractFromResultSet(rs);
                participations.add(participation);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return participations;
    }
}