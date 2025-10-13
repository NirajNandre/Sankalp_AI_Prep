package com.example.sankalp.repository.UserManagement;

import com.example.sankalp.model.UserManagement.MentorProfile;
import org.springframework.data.repository.CrudRepository;

public interface MentorRepository extends CrudRepository<MentorProfile,Integer> {
}
