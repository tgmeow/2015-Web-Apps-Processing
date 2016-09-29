/**
 * @title:   TangramHorse
 * Class:   Web Apps 2016 2nd Semester 1:00 
 * Date Feb 2, 2016
 * @author:  Tiger Mou
 * Description: This program draws three tangram horses. The pieces of the horse are dark and will randomly
 * flash with a lighter grey. When the pieces of the tangram horse are moused over,
 * they start shaking and mini tangram horses will spawn at the mouse location. These mini tangram horses will spin
 * in a random direction and initially move in a random direction and speed. The horses will bounce off of the left
 * and right sides of the screen. "Gravity" will pull the horses downward until they fall off the screen.
 * Once they fall off, they are removed from the program to clear up memory. Mousing over these mini tangram horses
 * will create even smaller tangram horses. The pieces of the mini tangram horses will change colors upon mouseover.
 * If the tangram horse was moving downwards, it will "bounce" off and move upwards. The moving mini tangram horses 
 * will leave streaks on the background. This is accomplished with a translucent rectangle drawn in the background every two
 * draw cycles instead of coloring the background a solid color. The top left of the screen will display the current
 * number of frames per second and the total number of active mini tangram horses.
  * 
 * "DIAGNOSTICS"
 * I can guarantee that the shapes are the correct sizes and are in the correct locations because of the way each shape was made.
 * Each shape is made with a corner at the origin and is sized with unit lengths and square roots of 2.
 * The shape is translated using a matrix by moving the point at the origin and rotating the shape about that origin to wherever
 * the shape needs to be. The location of the shape was determined by using relative distances and positionings from an "origin" point.
 * This origin point was the top right angle corner of the horse. The x coordinte of the shape below and touch it was determined by aligning
 * the X coordinates and by increasing the Y coordinate by the height of the triangle, which was calculated based on the unit length of the tangrams. 
 */

On my honor I did not give or receive any unauthorized aid on this assignment.
Tiger Mou