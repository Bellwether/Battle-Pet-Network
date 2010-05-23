class Leaderboard < ActiveRecord::Base
  SQL_RECENT = "created_at >= DATE_ADD(NOW(), INTERVAL -7 DAY)"
  
  validates_presence_of :rankable_type, :name, :ranked_count
  validates_inclusion_of :rankable_type, :in => %w(Pet Pack Shop)
  
  named_scope :indefatigable, :conditions => "leaderboards.name = 'Indefatigable Fighters'" , :limit => 1
  named_scope :overlords, :conditions => "leaderboards.name = 'Overlords'" , :limit => 1
  named_scope :strongest, :conditions => "leaderboards.name = 'Strongest Fighters'" , :limit => 1    
  
  class << self
    def rankables_for(scope)
      leaderboard = Leaderboard.send(scope.to_sym).first
      case scope.to_sym
        when :indefatigable
          sql_joins = "INNER JOIN challenges ON pets.id IN (attacker_id, defender_id)"
          sql_order = "COUNT(challenges.id) DESC"
          return Pet.all(:conditions => "challenges.#{Leaderboard::SQL_RECENT} AND challenges.status = 'resolved' ", 
                         :joins => sql_joins, 
                         :order => sql_order,
                         :limit => leaderboard.ranked_count)
        when :overlords
          sql_joins = "INNER JOIN users ON pets.user_id = users.id "
          conditions = "users.last_login_at >= DATE_ADD(NOW(), INTERVAL -7 DAY)"
          return Pet.active.all(:joins => sql_joins, :conditions => conditions)
        when :strongest
          avg_number_fights = connection.select_value "SELECT AVG(cnt) FROM ( " + 
                                                      "SELECT COUNT(challenges.id) AS cnt " +
                                                      "FROM challenges " +
                                                      "INNER JOIN pets ON pets.id = attacker_id OR pets.id = defender_id " +
                                                      "WHERE challenges.status = 'resolved' " +
                                                      "AND challenges.#{SQL_RECENT} " +
                                                      "GROUP BY pets.id) tbl"
          
          avg_number_wins = connection.select_value "SELECT AVG(cnt) FROM ( " +
                                                    "SELECT COUNT(battles.id) AS cnt " +
                                                    "FROM battles JOIN pets ON pets.id = battles.winner_id " +
                                                    "WHERE pets.status = 'active' " +
                                                    "AND battles.#{SQL_RECENT} " +
                                                    "GROUP BY pets.id) tbl"

          sql_joins = "INNER JOIN challenges ON pets.id IN (attacker_id, defender_id)"                                                    
          pet_number_wins = "SELECT COUNT(battles.id) FROM battles WHERE battles.winner_id = pets.id AND battles.#{SQL_RECENT}"
          pet_number_fights = "COUNT(challenges.id)"
          br_sql = "((#{avg_number_wins}) * (#{avg_number_fights}) + (#{pet_number_wins}) * (#{pet_number_fights})) / (#{avg_number_fights}) * (#{pet_number_fights})"
          return Pet.all(:conditions => "challenges.#{Leaderboard::SQL_RECENT} AND challenges.status = 'resolved' ", 
                         :joins => sql_joins, 
                         :order => br_sql,
                         :limit => leaderboard.ranked_count)
          
      end
      return []
    end
  end  
end