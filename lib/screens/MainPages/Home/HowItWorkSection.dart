import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HowItWorksSection extends StatefulWidget {
  @override
  _HowItWorksSectionState createState() => _HowItWorksSectionState();
}

class _HowItWorksSectionState extends State<HowItWorksSection> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      color: Colors.white,
      child: Column(
        children: [
          // Titre avec gradient et ombre
          ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: [Color(0xFF0099D6), Color(0xFF00CC99)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds);
            },
            child: Text(
              'Comment ça marche ?',
              style: GoogleFonts.roboto(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 40),
          // Étapes avec animations
          SlideTransition(
            position: _slideAnimation,
            child: _buildStep(
              icon: Icons.post_add,
              title: 'Publiez une demande',
              description: 'Décrivez votre besoin et fixez un budget.',
            ),
          ),
          SizedBox(height: 20),
          SlideTransition(
            position: _slideAnimation,
            child: _buildStep(
              icon: Icons.assignment_turned_in,
              title: 'Postulez aux offres',
              description: 'Trouvez des offres qui correspondent à vos compétences.',
            ),
          ),
          SizedBox(height: 20),
          SlideTransition(
            position: _slideAnimation,
            child: _buildStep(
              icon: Icons.chat,
              title: 'Discutez et finalisez',
              description: 'Communiquez avec les clients pour finaliser les détails.',
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildStep({required IconData icon, required String title, required String description}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFF0099D6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 40,
              color: Color(0xFF0099D6),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}