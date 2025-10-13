package com.example.sankalp.repository.UserManagement;

import com.example.sankalp.model.UserManagement.StudentProfile;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface StudentRepository extends CrudRepository<StudentProfile,Integer> {

    // Custom method to find a StudentProfile by the email in the nested Users object
    Optional<StudentProfile> findByUserEmail(String email);

    // Custom method to check if a student profile exists by the nested user_id
    boolean existsByUserUser_id(int userId);
}
