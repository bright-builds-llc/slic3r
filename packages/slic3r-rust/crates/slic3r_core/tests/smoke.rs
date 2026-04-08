use slic3r_core::workspace_marker;

#[test]
fn workspace_marker_is_exposed() {
    // Arrange
    let expected = "slic3r-core";

    // Act
    let actual = workspace_marker();

    // Assert
    assert_eq!(actual, expected);
}
