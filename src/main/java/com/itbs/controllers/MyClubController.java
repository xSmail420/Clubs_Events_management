package com.itbs.controllers;

import com.itbs.MainApp;
import com.itbs.models.Club;
import com.itbs.models.ParticipationMembre;
import com.itbs.models.User;
import com.itbs.services.ClubService;
import com.itbs.services.ParticipationMembreService;
import com.itbs.services.UserService;
import com.itbs.utils.SessionManager;

import javafx.application.Platform;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.chart.BarChart;
import javafx.scene.chart.NumberAxis;
import javafx.scene.chart.PieChart;
import javafx.scene.chart.XYChart;
import javafx.scene.control.*;
import javafx.scene.layout.BorderPane;
import javafx.stage.Stage;

import java.io.IOException;
import java.sql.SQLException;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

public class MyClubController {
    @FXML
    private BorderPane contentArea;
    @FXML
    private Label presidentNameLabel;
    @FXML
    private Label contentTitle;
    @FXML
    private Label clubNameLabel;
    @FXML
    private Label clubPointsLabel;
    @FXML
    private Label clubMembersCountLabel;
    @FXML
    private Label pendingRequestsCountLabel;
    
    // Club Details Tab
    @FXML
    private TextField nomCField;
    @FXML
    private TextArea descriptionField;
    @FXML
    private TextField logoField;
    @FXML
    private TextField imageField;
    @FXML
    private Label dateCreationLabel;
    @FXML
    private Label statusLabel;
    @FXML
    private Label pointsLabel;
    
    // Membership Requests Tab
    @FXML
    private ListView<ParticipationMembre> pendingRequestsList;
    @FXML
    private TextArea requestDetailsArea;
    @FXML
    private Button acceptRequestButton;
    @FXML
    private Button refuseRequestButton;
    
    // Members Tab
    @FXML
    private ListView<User> membersList;
    @FXML
    private TextField searchMembersField;
    @FXML
    private Label selectedMemberNameLabel;
    @FXML
    private Label selectedMemberEmailLabel;
    @FXML
    private Label selectedMemberPhoneLabel;
    @FXML
    private Label selectedMemberRoleLabel;
    
    // Statistics Tab
    @FXML
    private TabPane tabPane;
    @FXML
    private PieChart requestsStatusChart;
    @FXML
    private BarChart<Number, String> memberActivityChart;
    @FXML
    private Label totalMembersLabel;
    @FXML
    private Label acceptedRequestsLabel;
    @FXML
    private Label refusedRequestsLabel;
    @FXML
    private Label pendingRequestsLabel;
    
    // Navigation Buttons
    @FXML
    private Button myClubButton;
    @FXML
    private Button eventsButton;
    @FXML
    private Button productsButton;
    @FXML
    private Button pollsButton;
    @FXML
    private Button profileButton;
    @FXML
    private Button logoutButton;

    private final ClubService clubService = new ClubService();
    private final ParticipationMembreService participationService = new ParticipationMembreService();
    private final UserService userService = new UserService();
    
    private Club myClub;
    private User currentUser;
    private ParticipationMembre selectedRequest = null;
    private User selectedMember = null;
    
    private final ObservableList<ParticipationMembre> pendingRequests = FXCollections.observableArrayList();
    private final ObservableList<User> members = FXCollections.observableArrayList();
    private List<User> allMembers;
    private final DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    @FXML
    public void initialize() {
        try {
            // Verify user is a club president
            currentUser = SessionManager.getInstance().getCurrentUser();
            if (currentUser == null || !"PRESIDENT_CLUB".equals(currentUser.getRole().toString())) {
                navigateToLogin();
                return;
            }

            // Set president name
            presidentNameLabel.setText(currentUser.getFirstName() + " " + currentUser.getLastName());

            // Load president's club
            myClub = clubService.getClubByPresidentId1(currentUser.getId());
            if (myClub == null) {
                showError("Vous n'avez pas de club associé à votre compte.");
                return;
            }

            // Initialize UI
            contentTitle.setText("My Club Management");
            setActiveButton(myClubButton);
            
            // Load data
            loadClubDetails();
            loadPendingRequests();
            loadMembers();
            updateDashboardStats();

            // Setup lists
            setupPendingRequestsList();
            setupMembersList();

            // Setup search functionality
            searchMembersField.textProperty().addListener((observable, oldValue, newValue) -> searchMembers());

            // Setup tab listener for statistics
            tabPane.getSelectionModel().selectedItemProperty().addListener((obs, oldTab, newTab) -> {
                if (newTab != null && newTab.getText().equals("Statistiques")) {
                    Platform.runLater(this::loadStatistics);
                }
            });

        } catch (SQLException e) {
            showError("Erreur lors du chargement des données: " + e.getMessage());
        } catch (IOException e) {
            showError("Erreur lors de la navigation: " + e.getMessage());
        }
    }

    private void loadClubDetails() {
        clubNameLabel.setText(myClub.getNomC());
        clubPointsLabel.setText(String.valueOf(myClub.getPoints()));
        
        nomCField.setText(myClub.getNomC());
        descriptionField.setText(myClub.getDescription());
        logoField.setText(myClub.getLogo());
        imageField.setText(myClub.getImage());
        dateCreationLabel.setText(myClub.getDateCreation().format(dateFormatter));
        statusLabel.setText(myClub.getStatus());
        pointsLabel.setText(String.valueOf(myClub.getPoints()));
    }

    private void loadPendingRequests() throws SQLException {
        List<ParticipationMembre> requests = participationService.getPendingRequestsByClubId(myClub.getId());
        pendingRequests.clear();
        pendingRequests.addAll(requests);
        pendingRequestsCountLabel.setText(String.valueOf(requests.size()));
    }

    private void loadMembers() throws SQLException {
        allMembers = participationService.getAcceptedMembersByClubId(myClub.getId());
        members.clear();
        members.addAll(allMembers);
        clubMembersCountLabel.setText(String.valueOf(allMembers.size()));
    }

    private void setupPendingRequestsList() {
        pendingRequestsList.setCellFactory(param -> new ListCell<ParticipationMembre>() {
            @Override
            protected void updateItem(ParticipationMembre item, boolean empty) {
                super.updateItem(item, empty);
                if (empty || item == null || item.getUser() == null) {
                    setText(null);
                } else {
                    setText(item.getUser().getFullName() + " - " + 
                            item.getDateRequest().format(dateFormatter));
                }
            }
        });

        pendingRequestsList.setItems(pendingRequests);

        pendingRequestsList.getSelectionModel().selectedItemProperty().addListener((obs, oldVal, newVal) -> {
            if (newVal != null) {
                selectedRequest = newVal;
                displayRequestDetails(newVal);
                acceptRequestButton.setDisable(false);
                refuseRequestButton.setDisable(false);
            } else {
                selectedRequest = null;
                requestDetailsArea.clear();
                acceptRequestButton.setDisable(true);
                refuseRequestButton.setDisable(true);
            }
        });
    }

    private void setupMembersList() {
        membersList.setCellFactory(param -> new ListCell<User>() {
            @Override
            protected void updateItem(User item, boolean empty) {
                super.updateItem(item, empty);
                if (empty || item == null) {
                    setText(null);
                } else {
                    setText(item.getFullName() + " (" + item.getEmail() + ")");
                }
            }
        });

        membersList.setItems(members);

        membersList.getSelectionModel().selectedItemProperty().addListener((obs, oldVal, newVal) -> {
            if (newVal != null) {
                selectedMember = newVal;
                displayMemberDetails(newVal);
            } else {
                selectedMember = null;
                clearMemberDetails();
            }
        });
    }

    private void displayRequestDetails(ParticipationMembre request) {
        User user = request.getUser();
        StringBuilder details = new StringBuilder();
        details.append("Nom complet: ").append(user.getFullName()).append("\n");
        details.append("Email: ").append(user.getEmail()).append("\n");
        details.append("Téléphone: ").append(user.getPhone()).append("\n");
        details.append("Date de demande: ").append(request.getDateRequest().format(dateFormatter)).append("\n");
        details.append("Statut: ").append(request.getStatut()).append("\n");
        if (request.getDescription() != null && !request.getDescription().isEmpty()) {
            details.append("\nDescription:\n").append(request.getDescription());
        }
        requestDetailsArea.setText(details.toString());
    }

    private void displayMemberDetails(User user) {
        selectedMemberNameLabel.setText(user.getFullName());
        selectedMemberEmailLabel.setText(user.getEmail());
        selectedMemberPhoneLabel.setText(user.getPhone());
        selectedMemberRoleLabel.setText(user.getRole().toString());
    }

    private void clearMemberDetails() {
        selectedMemberNameLabel.setText("-");
        selectedMemberEmailLabel.setText("-");
        selectedMemberPhoneLabel.setText("-");
        selectedMemberRoleLabel.setText("-");
    }

    @FXML
    private void updateClubDetails() {
        try {
            // Update club fields
            myClub.setNomC(nomCField.getText().trim());
            myClub.setDescription(descriptionField.getText().trim());
            myClub.setLogo(logoField.getText().trim());
            myClub.setImage(imageField.getText().trim());

            // Validate
            if (myClub.getNomC().isEmpty()) {
                showError("Le nom du club ne peut pas être vide.");
                return;
            }

            // Update in database
            clubService.modifier(myClub);
            
            // Refresh display
            clubNameLabel.setText(myClub.getNomC());
            
            showSuccess("Les détails du club ont été mis à jour avec succès !");
        } catch (Exception e) {
            showError("Erreur lors de la mise à jour: " + e.getMessage());
        }
    }

    @FXML
    private void acceptRequest() {
        if (selectedRequest == null) {
            showError("Veuillez sélectionner une demande.");
            return;
        }

        try {
            selectedRequest.setStatut("accepte");
            participationService.modifier(selectedRequest);
            
            // Refresh lists
            loadPendingRequests();
            loadMembers();
            updateDashboardStats();
            
            requestDetailsArea.clear();
            acceptRequestButton.setDisable(true);
            refuseRequestButton.setDisable(true);
            
            showSuccess("Demande acceptée avec succès !");
        } catch (Exception e) {
            showError("Erreur lors de l'acceptation: " + e.getMessage());
        }
    }

    @FXML
    private void refuseRequest() {
        if (selectedRequest == null) {
            showError("Veuillez sélectionner une demande.");
            return;
        }

        try {
            selectedRequest.setStatut("refuse");
            participationService.modifier(selectedRequest);
            
            // Refresh list
            loadPendingRequests();
            updateDashboardStats();
            
            requestDetailsArea.clear();
            acceptRequestButton.setDisable(true);
            refuseRequestButton.setDisable(true);
            
            showSuccess("Demande refusée.");
        } catch (Exception e) {
            showError("Erreur lors du refus: " + e.getMessage());
        }
    }

    @FXML
    private void searchMembers() {
        String searchText = searchMembersField.getText().trim().toLowerCase();
        if (searchText.isEmpty()) {
            members.setAll(allMembers);
        } else {
            List<User> filteredMembers = allMembers.stream()
                    .filter(user -> user.getFullName().toLowerCase().contains(searchText) ||
                                  user.getEmail().toLowerCase().contains(searchText))
                    .collect(Collectors.toList());
            members.setAll(filteredMembers);
        }
    }

    private void updateDashboardStats() {
        try {
            loadMembers();
            loadPendingRequests();
        } catch (SQLException e) {
            showError("Erreur lors de la mise à jour des statistiques: " + e.getMessage());
        }
    }

    private void loadStatistics() {
        try {
            // Load request statistics
            int totalRequests = participationService.getTotalRequestsByClubId(myClub.getId());
            int accepted = participationService.getAcceptedRequestsCountByClubId(myClub.getId());
            int refused = participationService.getRefusedRequestsCountByClubId(myClub.getId());
            int pending = participationService.getPendingRequestsCountByClubId(myClub.getId());

            // Update labels
            totalMembersLabel.setText(String.valueOf(accepted));
            acceptedRequestsLabel.setText(String.valueOf(accepted));
            refusedRequestsLabel.setText(String.valueOf(refused));
            pendingRequestsLabel.setText(String.valueOf(pending));

            // Update pie chart
            if (requestsStatusChart != null) {
                ObservableList<PieChart.Data> pieChartData = FXCollections.observableArrayList(
                    new PieChart.Data("Acceptées (" + accepted + ")", accepted),
                    new PieChart.Data("Refusées (" + refused + ")", refused),
                    new PieChart.Data("En attente (" + pending + ")", pending)
                );
                requestsStatusChart.setData(pieChartData);
                requestsStatusChart.setTitle("Répartition des demandes d'adhésion");
            }

            // Update bar chart (member activity - placeholder)
            if (memberActivityChart != null) {
                memberActivityChart.getData().clear();
                XYChart.Series<Number, String> series = new XYChart.Series<>();
                series.setName("Activité des membres");
                
                // Add sample data - you can replace with actual activity data
                series.getData().add(new XYChart.Data<>(accepted, "Membres actifs"));
                series.getData().add(new XYChart.Data<>(myClub.getPoints(), "Points du club"));
                
                memberActivityChart.getData().add(series);
                
                // Style bars
                Platform.runLater(() -> {
                    Set<Node> nodes = memberActivityChart.lookupAll(".chart-bar");
                    for (Node node : nodes) {
                        node.setStyle("-fx-bar-fill: #3498db;");
                        node.setOnMouseEntered(e -> node.setStyle("-fx-bar-fill: #2980b9;"));
                        node.setOnMouseExited(e -> node.setStyle("-fx-bar-fill: #3498db;"));
                    }
                });
            }

        } catch (Exception e) {
            showError("Erreur lors du chargement des statistiques: " + e.getMessage());
        }
    }

    private void showSuccess(String message) {
        Alert alert = new Alert(Alert.AlertType.INFORMATION);
        alert.setTitle("Succès");
        alert.setHeaderText(null);
        alert.setContentText(message);
        alert.showAndWait();
    }

    private void showError(String message) {
        Alert alert = new Alert(Alert.AlertType.ERROR);
        alert.setTitle("Erreur");
        alert.setHeaderText(null);
        alert.setContentText(message);
        alert.showAndWait();
    }

    @FXML
    private void showMyClub(ActionEvent actionEvent) {
        contentTitle.setText("My Club Management");
        setActiveButton(myClubButton);
        // Already in My Club view
    }

    @FXML
    private void navigateToProfile(ActionEvent actionEvent) throws IOException {
        FXMLLoader loader = new FXMLLoader(MainApp.class.getResource("views/profile.fxml"));
        Parent root = loader.load();
        Stage stage = (Stage) ((Node) actionEvent.getSource()).getScene().getWindow();
        Scene scene = new Scene(root);
        scene.getStylesheets().add(getClass().getResource("/com/itbs/styles/uniclubs.css").toExternalForm());
        stage.setTitle("President Profile - UNICLUBS");
        stage.setScene(scene);
        stage.setMaximized(true);
        stage.show();
    }

    @FXML
    private void handleLogout(ActionEvent event) {
        SessionManager.getInstance().clearSession();
        try {
            navigateToLogin();
        } catch (IOException e) {
            e.printStackTrace();
            showError("Erreur lors de la déconnexion");
        }
    }

    private void navigateToLogin() throws IOException {
        FXMLLoader loader = new FXMLLoader(getClass().getResource("/com/itbs/views/login.fxml"));
        Parent root = loader.load();

        Stage stage = (Stage) (contentArea != null ? contentArea.getScene().getWindow()
                : (presidentNameLabel != null ? presidentNameLabel.getScene().getWindow() : null));

        if (stage != null) {
            MainApp.setupStage(stage, root, "Login - UNICLUBS", true);
            stage.show();
        } else {
            stage = new Stage();
            MainApp.setupStage(stage, root, "Login - UNICLUBS", true);
            stage.show();

            if (contentArea != null && contentArea.getScene() != null &&
                    contentArea.getScene().getWindow() != null) {
                ((Stage) contentArea.getScene().getWindow()).close();
            }
        }
    }

    private void setActiveButton(Button activeButton) {
        for (Button btn : new Button[] { myClubButton, eventsButton, productsButton, pollsButton }) {
            if (btn != null) {
                btn.getStyleClass().remove("active");
            }
        }
        if (activeButton != null) {
            activeButton.getStyleClass().add("active");
        }
    }
}